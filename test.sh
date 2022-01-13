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
url_output() {
    NAME=${1}
    APPBOX_USER=$(echo "${HOSTNAME}" | awk -F'.' '{print $2}')
    echo -e "\n\n\n\n\n
        Installation sucessful! Please point your browser to:
        \e[4mhttps://${HOSTNAME}/${NAME}\e[39m\e[0m
        
        You can continue the configuration from there.
        \e[96mMake sure you protect the app by setting up a username/password in the app's settings!\e[39m
        
        \e[91mIf you want to use another appbox app in the settings of ${NAME}, make sure you access it on port 80, and without https, for example:
        \e[4mhttp://rutorrent.${APPBOX_USER}.appboxes.co\e[39m\e[0m
        \e[95mIf you want to access Plex from one of these installed apps use port 32400 for example:
        \e[4mhttp://plex.${APPBOX_USER}.appboxes.co:32400\e[39m\e[0m
        
        That's because inside this container, we don't go through the appbox proxy! \n\n\n\n\n\n"
}

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
