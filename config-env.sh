#!/bin/bash
# vim:sw=4:ts=4:et

# Cria um arquivo NGINX de configuração responsável por gerar dinamicamente
# as variáveis de ambiente prefixadas com GVAR_, usando o módulo `sub_filter`
# Veja mais em: https://nginx.org/en/docs/http/ngx_http_sub_module.html

set -e

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

ME=$(basename "$0")
DEFAULT_CONF_DIR=/etc/nginx/conf.location.d
DEFAULT_CONF_FILE=$DEFAULT_CONF_DIR/nginx.location-root.conf

# Verifica se há pelo menos uma variável de ambiente prefixada com GVAR_.
if [[ $(printenv | grep -c '^GVAR_') -gt 0 ]]; then

    # Cria o diretório de configuração do NGINX.
    mkdir -p $DEFAULT_CONF_DIR

    # Cria um arquivo NGINX de configuração vazio.
    echo "location / {" > $DEFAULT_CONF_FILE

    # Percorre todas as variáveis de ambiente.
    while IFS='=' read -r name value ; do
        if [[ $name == GVAR_* ]]; then
            # Adiciona a variável de ambiente ao arquivo de NGINX de configuração.
            echo "    sub_filter '__${name}__' '$value';" >> $DEFAULT_CONF_FILE
        fi
    done < <(env)

    {
      # Garantir que seja substituído todas as ocorrências da variável de ambiente.
      echo "    sub_filter_once off;"

      # Garantir que seja substituído em qualquer tipo de arquivo.
      echo "    sub_filter_types *;"

      # Necessário para que a substituição funcione corretamente.
      echo "    gzip_proxied any;"
      echo "    gzip_types text/plain text/css application/json text/javascript application/javascript text/xml application/xml application/xml+rss;"
      echo "    gunzip on;"
      echo "}"
    } >> $DEFAULT_CONF_FILE

    entrypoint_log "$ME: info: Arquivo $DEFAULT_CONF_FILE criado com sucesso!"
else
    entrypoint_log "$ME: info: Não há variáveis de ambiente prefixadas com GVAR_"
fi
