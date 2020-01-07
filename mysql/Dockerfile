# Pull base image.
FROM alpine:latest

# Install essential packages.
RUN apk add --no-cache mariadb mariadb-client tzdata

# Install gosu
COPY --from=gosu/alpine /usr/local/bin/gosu /usr/local/bin/gosu

# Copy entrypoint file.
COPY start.sh /usr/local/bin/

# Make entrypoint file executable.
RUN chmod +x /usr/local/bin/start.sh

# Set entrypoint.
ENTRYPOINT [ "start.sh" ]

# Set command.
CMD [ "mysqld" ]

# Expose port(s).
EXPOSE 3306