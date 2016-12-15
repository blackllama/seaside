#!/bin/bash

url="http://localhost:80"
count=0
max=60

echo "checking $url"

while [ $count -le $max ]
do
    response=$(curl -o /dev/null --silent --write-out '%{http_code}\n' $url)

    if [ $response -eq "200" ]
    then
      echo "cool"
      exit 0
    fi
    
    echo "Waiting $count of $max seconds"
    ((count++))
    
    sleep 1
done

echo "Web service not running"
exit 1