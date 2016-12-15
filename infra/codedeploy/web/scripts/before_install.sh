#!/bin/bash

sudo apt-get update

# Remove existing config
rm -f /etc/nginx/sites-available/default
rm -f /etc/supervisor/conf.d/seasideweb.conf