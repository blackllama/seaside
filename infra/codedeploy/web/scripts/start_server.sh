#!/bin/bash
sudo service supervisor stop
sudo service supervisor start

url="http://localhost:5000"
count=0
max=60
echo "checking $url"

while [ $count -le $max ]
do
    response=$(curl -o /dev/null --silent --write-out '%{http_code}\n' $url)

    if [ $response -eq "200" ]
    then
      echo "$url is running"
      break
    fi
    
    echo "Waiting $count of $max seconds"
    ((count++))
    
    sleep 1
done

if [ $count -gt $max ] 
then
  echo "$url was not running"
  exit 1
fi

url="http://localhost:80"
count=0
max=60

sudo service nginx stop
sudo service nginx start

echo "checking $url"

while [ $count -le $max ]
do
    response=$(curl -o /dev/null --silent --write-out '%{http_code}\n' $url)

    if [ $response -eq "200" ]
    then
      echo "$url is running"
      break
    fi
    
    echo "Waiting $count of $max seconds"
    ((count++))
    
    sleep 1
done

if [ $count -gt $max ] 
then
  echo "$url was not running"
  exit 1
fi