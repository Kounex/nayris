import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as compression from 'compression';

import { json } from 'express';
import { CloudflareAuthGuard } from './auth/cloudflare.guard';
import { AppModule } from './app.module';


async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bodyParser: false, },);

  app.setGlobalPrefix('api/v1');

  app.enableCors({
    origin: [
      'https://nayris.kounex.com',
      'http://localhost:8888',
      'http://127.0.0.1:8888',
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
    credentials: true,
  });
  app.use(compression());
  app.use(json({ limit: '10mb' }));

  app.useGlobalGuards(new CloudflareAuthGuard());

  const config = new DocumentBuilder()
    .setTitle('NAYRIS API')
    .setDescription('Endpoints to fetch meta information for YouTube videos and trigger a convert and download to .mp3')
    .setVersion('1.0')
    .addTag('youtube')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(process.env.PORT || 4444);
}
bootstrap();
