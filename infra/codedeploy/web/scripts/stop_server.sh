#!/bin/bash
set -e

sudo service nginx stop
sudo service supervisor stop

# nginx_running=`pgrep nginx`
# if [[ -n $nginx_running ]]; then
#     sudo service nginx stop
# fi

# supervisor_running=`pgrep supervisord`
# if [[ -n $supervisor_running ]]; then
#     sudo service supervisor stop
# fi

