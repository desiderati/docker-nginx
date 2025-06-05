#!/bin/bash
#
# Copyright (c) 2025 - Felipe Desiderati
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

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
