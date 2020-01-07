# Pull base image.
FROM memcached:alpine

# Login as root
USER root

# Install essential packages.
RUN apk add --no-cache tzdata

# Install gosu
COPY --from=gosu/alpine /usr/local/bin/gosu /usr/local/bin/gosu

# Copy entrypoint file.
COPY start.sh /usr/local/bin/

# Make entrypoint file executable.
RUN chmod +x /usr/local/bin/start.sh

# Set entrypoint.
ENTRYPOINT [ "start.sh" ]

# Delete base image generated files
RUN rm /usr/local/bin/docker-entrypoint.sh /entrypoint.sh

# Set command.
CMD [ "memcached" ]