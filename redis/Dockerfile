# Pull base image.
FROM redis:alpine

# Copy entrypoint file.
COPY start.sh /usr/local/bin/

# Make entrypoint file executable.
RUN chmod +x /usr/local/bin/start.sh

# Set entrypoint.
ENTRYPOINT [ "start.sh" ]

# Set command.
CMD [ "redis-server", "/etc/conf.d/redis.conf" ]