FROM node:17

# Have a root user which has superuser privileges
USER root

# Update base environment
RUN apt-get update

# Symlink python3 dir to "normal" python dir
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install ffmpeg
RUN apt-get -y install ffmpeg

# Download youtube-dl binary and make it executable
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp