#!/bin/bash

url="http://localhost:80"
response=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $url)

if [ $response -ne "200" ]
    then
        echo "Web service not running"
        exit 1
    else
        echo "Web service running"
        exit 0
fi