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
ENV CLOUDFLARE_TEAM_DOMAIN=
ENV YTDLP_PATH=/usr/local/bin/yt-dlp

WORKDIR /nayris

# Install python3 (required for yt-dlp) and curl
RUN apt-get update && \
    apt-get install -y python3 python-is-python3 curl ffmpeg wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Install PhantomJS (legacy JS runtime often helps with yt-dlp on certain sites)
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ && \
    ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin && \
    rm phantomjs-2.1.1-linux-x86_64.tar.bz2

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
