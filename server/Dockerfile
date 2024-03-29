# ------ BUILDER ------
FROM node:17 as builder

# Set workdir where the application to build will reside
WORKDIR /nayris

# Copy all files over to the workdir of the build process
ADD ./ ./

# Install dependencies and build the application
RUN npm install && npm run build

# ------ RUNNER ------
FROM registry.access.redhat.com/ubi8/nodejs-16:latest

ENV PORT=4444

WORKDIR /nayris

COPY --from=builder /nayris/dist ./dist
COPY --from=builder /nayris/node_modules ./node_modules
COPY --from=builder /nayris/package.json ./package.json

# Have a root user which has superuser privileges
USER root

# Update base environment
RUN dnf -y update

# Make sure we have the latest base
RUN dnf -y upgrade

# Install and enable EPEL (Extra Packages for Enterprise Linux)
RUN dnf -y install --nogpgcheck https://download.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Install and enable RPM Fusion
RUN dnf -y install https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
# RUN dnf -y install --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm

# RUN dnf config-manager --enable PowerTools
# RUN subscription-manager repos --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms"

# Needed asa dependency for ffmpeg
RUN dnf -y install https://rpmfind.net/linux/epel/7/x86_64/Packages/s/SDL2-2.0.14-2.el7.x86_64.rpm

# Install python3
RUN dnf -y install -y python3

# Symlink python3 dir to "normal" python dir
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install ffmpeg now that we have EPEL and RPM Fusion
RUN dnf -y install ffmpeg

# Download youtube-dl binary and make it executable
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp

# Change group and access rights so these folders / executables can
# be used as non root for security reasons
RUN chgrp 0 /usr/local/bin/yt-dlp && \
    chmod g=u /usr/local/bin/yt-dlp 

RUN chgrp -R 0 ./ && \
    chmod -R g=u ./ 

# Change user to non root
USER 1000

ENTRYPOINT ["npm", "run", "start:prod"]