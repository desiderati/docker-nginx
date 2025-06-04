#!/bin/bash
# vim:sw=4:ts=4:et

# Creates an NGINX configuration file responsible for dynamically injecting
# environment variables prefixed with GVAR_, using the `sub_filter` module.
# See more at: https://nginx.org/en/docs/http/ngx_http_sub_module.html

set -e

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

ME=$(basename "$0")
DEFAULT_CONF_DIR=/etc/nginx/conf.location.d
DEFAULT_CONF_FILE=$DEFAULT_CONF_DIR/nginx.location-root.conf

# Checks if there is at least one environment variable prefixed with GVAR_.
if [[ $(printenv | grep -c '^GVAR_') -gt 0 ]]; then

    # Creates the NGINX configuration directory.
    mkdir -p $DEFAULT_CONF_DIR

    # Creates an empty NGINX configuration file.
    echo "location / {" > $DEFAULT_CONF_FILE

    # Iterates over all environment variables.
    while IFS='=' read -r name value ; do
        if [[ $name == GVAR_* ]]; then
            # Adds the environment variable to the NGINX configuration file.
            echo "    sub_filter '__${name}__' '$value';" >> $DEFAULT_CONF_FILE
        fi
    done < <(env)

    {
      # Ensures all occurrences of the environment variable are replaced.
      echo "    sub_filter_once off;"

      # Ensures replacement works on any type of file.
      echo "    sub_filter_types *;"

      # Required for the substitution to work correctly.
      echo "    gzip_proxied any;"
      echo "    gzip_types text/plain text/css application/json text/javascript application/javascript text/xml application/xml application/xml+rss;"
      echo "    gunzip on;"
      echo "}"
    } >> $DEFAULT_CONF_FILE

    entrypoint_log "$ME: info: File $DEFAULT_CONF_FILE created successfully!"
else
    entrypoint_log "$ME: info: No environment variables found with GVAR_ prefix!"
fi
