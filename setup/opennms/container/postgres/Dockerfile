# Start with the official Postgres 14 (Stable and compatible with OpenNMS)
FROM postgres:14

# Copy our custom configuration into the container
COPY custom.conf /etc/postgresql/postgresql.conf

# Override the default command to use our config file
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]