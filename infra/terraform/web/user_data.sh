#!/bin/bash
apt-get -y update
apt-get -y install awscli
apt-get -y install ruby2.0
apt-get -y install nginx
apt-get -y install supervisor
apt-get -y install python-pip

# make sure we are on the latest aws cli
sudo pip install --upgrade awscli

# install code deploy
cd /home/ubuntu
aws s3 cp s3://aws-codedeploy-${aws-region-id}/latest/install . \
    --region ${aws-region-id}
chmod +x ./install
./install auto

# install dotnet cli
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
sudo apt-get update
sudo apt-get install dotnet-dev-1.0.0-preview2.1-003177 --assume-yes
export DOTNET_CLI_TELEMETRY_OPTOUT=1