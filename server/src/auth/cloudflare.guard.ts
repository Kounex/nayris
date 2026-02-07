import {
    CanActivate,
    ExecutionContext,
    Injectable,
    UnauthorizedException,
} from '@nestjs/common';
import { createRemoteJWKSet, jwtVerify } from 'jose';

@Injectable()
export class CloudflareAuthGuard implements CanActivate {
    private readonly JWKS;

    constructor() {
        const teamDomain = process.env.CLOUDFLARE_TEAM_DOMAIN;
        if (teamDomain) {
            this.JWKS = createRemoteJWKSet(
                new URL(
                    `https://${teamDomain}.cloudflareaccess.com/cdn-cgi/access/certs`,
                ),
            );
        } else {
            console.warn(
                '[AUTH] CLOUDFLARE_TEAM_DOMAIN is not set. Cloudflare Access verification is effectively mocked for dev.',
            );
        }
    }

    async canActivate(context: ExecutionContext): Promise<boolean> {
        const request = context.switchToHttp().getRequest();

        // In local development (or without config), bypass verification
        if (
            process.env.NODE_ENV !== 'production' &&
            !process.env.CLOUDFLARE_TEAM_DOMAIN
        ) {
            return true;
        }

        if (!this.JWKS) {
            // Configuration error in production
            console.error(
                '[AUTH] Critical: CLOUDFLARE_TEAM_DOMAIN missing in production environment.',
            );
            throw new UnauthorizedException('Server Authentication Misconfiguration');
        }

        const token = request.headers['cf-access-jwt-assertion'];

        if (!token) {
            throw new UnauthorizedException('Missing Cloudflare Access Token');
        }

        try {
            const { payload } = await jwtVerify(token, this.JWKS, {
                issuer: `https://${process.env.CLOUDFLARE_TEAM_DOMAIN}.cloudflareaccess.com`,
            });

            // Attach user info to request object for use in controllers
            request['user'] = payload;
            return true;
        } catch (err) {
            console.error('Cloudflare Access Token Verification Failed:', err.message);
            throw new UnauthorizedException('Invalid Cloudflare Access Token');
        }
    }
}
