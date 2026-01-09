# ------ BUILDER ------
FROM node:20 as builder

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
FROM node:20-slim

ENV PORT=4444

WORKDIR /nayris

# Install python3 (required for yt-dlp) and curl
RUN apt-get update && \
    apt-get install -y python3 python-is-python3 curl ffmpeg && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /nayris/dist ./dist
COPY --from=builder /nayris/node_modules ./node_modules
COPY --from=builder /nayris/package.json ./package.json

# Download youtube-dl binary and make it executable
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp

# Change group and access rights so these folders / executables can
# be used as non root for security reasons
RUN mkdir tmp && \
    chown -R node:node ./

# Change user to non root
USER node

ENTRYPOINT ["npm", "run", "start"]