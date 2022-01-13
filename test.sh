#!/usr/bin/env bash
# Appbox installer for Ubuntu 20.04
#
# Just run this on your Ubuntu VNC app via SSH or in the terminal (Applications > Terminal Emulator) using:
# sudo bash -c "bash <(curl -Ls https://raw.githubusercontent.com/coder8338/appbox_installer/Ubuntu-20.04/appbox_installer.sh)"
#
# We do not work for appbox, we're a friendly community helping others out, we will try to keep this as uptodate as possible!

set -e
set -u

export DEBIAN_FRONTEND=noninteractive


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
configure_nginx
