FROM nginx:1.25.5

# Disable the default location and remove IPV6 configuration!
RUN rm /etc/nginx/conf.d/default.conf
RUN rm /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

RUN mkdir -p /etc/nginx/html/http-error/
COPY /http-error/* /etc/nginx/html/http-error/

# Forward request and error logs to docker log collector.
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

COPY config-env.sh /docker-entrypoint.d/00-config-env.sh
RUN chmod +x /docker-entrypoint.d/00-config-env.sh

COPY error.pages /etc/nginx/error.pages
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.server-default.conf /etc/nginx/conf.d/nginx.server-default.conf
COPY nginx.status.conf /etc/nginx/conf.d/nginx.status.conf

COPY wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/wait-for-it

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y vim-tiny

# Disabled NGINX application auto-discovery. Kept for documentation purposes.
#LABEL "com.datadoghq.ad.check_names"='["nginx"]'
#LABEL "com.datadoghq.ad.init_configs"='[{}]'
#LABEL "com.datadoghq.ad.instances"='[{"nginx_status_url": "http://localhost:81/nginx_status"}]'

LABEL "com.datadoghq.ad.logs"='[{"source": "nginx", "service": "nginx"}]'

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
