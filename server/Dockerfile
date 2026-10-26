# ------ BUILDER ------
FROM node:26.12.1-bookworm@sha256:5c4012d11d9857c42713ba511fbc19645cac1706bb710d51d42b0d301dff7f88 as builder

# Set workdir where the application to build will reside
WORKDIR /nayris

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source and build
COPY . .
RUN npm run build && npm prune --production

# ------ RUNNER ------
FROM node:26.12.1-slim@sha256:36793bcbb160a6a16cede1e62b93f84e26b78a972a8a4c0b879c1c12f22761ec

ENV PORT=4444
ENV CLOUDFLARE_TEAM_DOMAIN=
ENV YTDLP_PATH=/usr/local/bin/yt-dlp

WORKDIR /nayris

# Install python3 (required for yt-dlp) and curl
RUN apt-get update && \
    apt-get install -y python3 python-is-python3 curl ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Install Deno (modern JS runtime preferred by yt-dlp)
COPY --from=denoland/deno:bin-1.46.3 /deno /usr/local/bin/deno
# (Using a fixed version for stability, or use :bin for latest)

COPY --from=builder /nayris/dist ./dist
COPY --from=builder /nayris/node_modules ./node_modules
COPY --from=builder /nayris/package.json ./package.json

# Download youtube-dl binary (using nightly implementation to fix 403 errors faster)
# RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp
# Often, the release binary is enough, but if 403 persists, we might need:
RUN curl -L https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp

# Change group and access rights so these folders / executables can
# be used as non root for security reasons
RUN mkdir tmp && \
    chown -R node:node ./

# Change user to non root
USER node

ENTRYPOINT ["npm", "run", "start:prod"]
