#!/bin/bash
set -e

nginx_running=`pgrep nginx`
if [[ -n $nginx_running ]]; then
	service nginx stop
fi

supervisor_running=`pgrep supervisord`
if [[ -n $supervisor_running ]]; then
	service supervisor stop
fi