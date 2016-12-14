#!/bin/bash

sudo apt-get update
sudo apt-get install dotnet-dev-1.0.0-preview2-003156 --assume-yes #todo remove this

# Remove existing config
rm -f /etc/nginx/sites-available/default
rm -f /etc/supervisor/conf.d/seasideweb.conf