#!/bin/sh

BINARY_DIRECTORY=/opt/bin

echo "--------------------- Start: Initialize ---------------------"

# Make derectory for uploading directory
# Reference: https://www.packer.io/docs/provisioners/file.html#directory-uploads
mkdir /home/rancher/project
sudo mkdir $BINARY_DIRECTORY

# Add path
export PATH=$PATH:$BINARY_DIRECTORY

# Make startup script
sudo mkdir -p /opt/rancher/bin
sudo touch /opt/rancher/bin/start.sh
sudo chmod 755 /opt/rancher/bin/start.sh

# Add launch command to startup script
cat <<SCRIPT | sudo tee -a /opt/rancher/bin/start.sh > /dev/null
# Add path
export PATH=$PATH:$BINARY_DIRECTORY
# Start webhook
webhook -hooks /home/rancher/project/hooks.json -verbose &
SCRIPT

echo "--------------------- Finish: Initialize ---------------------"



echo "--------------------- Start: Install adnanh/webhook ---------------------"

# Download webhook
wget -q https://github.com/adnanh/webhook/releases/download/2.6.9/webhook-linux-amd64.tar.gz

# Extract app
gzip -cd webhook-linux-amd64.tar.gz | tar -xvf -
sudo mv ./webhook-linux-amd64/webhook $BINARY_DIRECTORY
# Remove archive
rm -rf webhook-linux-amd64
rm webhook-linux-amd64.tar.gz

echo "--------------------- Finish: Install adnanh/webhook ------------------"



echo "--------------------- Start: Install docker-compose ---------------------"

DOCKER_COMPOSE_VERSION=1.23.2

# Download webhook
sudo wget -q https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -O $BINARY_DIRECTORY/docker-compose
# Add execute authority to users
sudo chmod +x $BINARY_DIRECTORY/docker-compose

echo "--------------------- Finish: Install docker-compose ---------------------"



echo "--------------------- Start: Setup ---------------------"

docker-compose --version
webhook -version

echo "--------------------- Finish: Setup ---------------------"
