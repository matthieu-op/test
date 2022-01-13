configure_nginx

configure_nginx() {
    NAME=up
    PORT=3001
    OPTION=${3:-default}
    if ! grep -q "/${NAME} {" /etc/nginx/sites-enabled/default; then
        sed -i '/server_name _/a \
        location /'${NAME}' {\
                proxy_pass http://127.0.0.1:'${PORT}';\
        }' /etc/nginx/sites-enabled/default

        if [ "${OPTION}" == 'subfilter' ]; then
            sed -i '/location \/'${NAME}' /a \
                sub_filter "http://"  "https://";\
                sub_filter_once off;' /etc/nginx/sites-enabled/default
        fi
    fi
    pkill -HUP nginx
    url_output "${NAME}"
}
