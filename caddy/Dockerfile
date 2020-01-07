# Pull base image.
FROM alpine:latest

# Install essential packages.
RUN apk add --no-cache caddy tzdata

# Install gosu
COPY --from=gosu/alpine /usr/local/bin/gosu /usr/local/bin/gosu

#
RUN echo "import /etc/caddy/conf.d/*.conf" >> /etc/caddy/caddy.conf

# Change working directory
WORKDIR /srv/www

# Copy entrypoint file.
COPY start.sh /usr/local/bin/

# Make entrypoint file executable.
RUN chmod +x /usr/local/bin/start.sh

# Set entrypoint.
ENTRYPOINT [ "start.sh" ]

# Set command.
CMD [ "caddy", "-conf", "/etc/caddy/caddy.conf", "-log", "/var/log/caddy.log" ]

# Expose port(s).
EXPOSE 80 443