# ------ BUILDER ------
FROM redhat/ubi8:latest as builder

ARG CUSTOM_SERVER_URL

# Set the working directory
WORKDIR /frontend

RUN dnf upgrade --refresh -y && \
    dnf install -y git unzip xz curl which

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"

# Mark the flutter directory as safe for git
RUN git config --global --add safe.directory /usr/local/flutter

# Run basic check to download Dark SDK
RUN flutter doctor

# Used for the flutter configs
RUN mkdir /.config && \
    mkdir /.pub-cache

# Explicitly enable web support to ensure 'build web' options are available
RUN flutter config --enable-web

# Update permissions for all related paths (flutter + project)
# so a non root user can use those explicitly but none else
# 
# NOT NECESSARY IN THE BUILDER IMAGE (TO MY KNOWLEDGE)
#
# RUN chgrp -R 0 /usr/local/flutter && \
#     chmod -R g=u /usr/local/flutter 

# RUN chgrp -R 0 /.config && \
#     chmod -R g=u /.config 

# RUN chgrp -R 0 /.pub-cache && \
#     chmod -R g=u /.pub-cache 

# RUN chgrp -R 0 ./ && \
#     chmod -R g=u ./

# Copy pubspec files first to cache dependencies
COPY pubspec.* ./

# Get all flutter dependencies
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build static web files
RUN flutter build web --dart-define "CUSTOM_SERVER_URL=${CUSTOM_SERVER_URL}"

# ------ RUNNER ------
FROM registry.access.redhat.com/ubi8/nginx-122

# Copy static files to folder where nginx will serve them
COPY --from=builder /frontend/build/web .

# Change group and access rights so these folders / executables can
# be used as non root for security reasons
# RUN chgrp -R 0 /var/cache/nginx && \
#     chmod -R g=u /var/cache/nginx

# RUN chgrp -R 0 /etc/nginx/conf.d && \
#     chmod -R g=u /etc/nginx/conf.d

# Change user to non root
USER 1000

CMD nginx -g "daemon off;"