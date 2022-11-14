#!/bin/bash

# Update and install packages
apt-get update && apt-get upgrade -y && apt-get install entr unzip -y

# Remove aws cli v1
apt-get remove awscli

# Install aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install docker
curl -sSL https://get.docker.com | sh

# Install wg-easy
WG_HOST=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
docker run -d \
  --name=wg-easy \
  -e WG_HOST=$WG_HOST \
  -e PASSWORD=\!Passw0rd \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  weejewel/wg-easy

# Restore existing configuration (if any)
docker stop wg-easy
aws s3 cp s3://dodbrian/wg-test/wg0.json /root/.wg-easy/
docker start wg-easy

# Watch configuration updates and copy to S3
while true; do echo "/root/.wg-easy/wg0.json" | sudo entr -d -n aws s3 cp /root/.wg-easy/wg0.json s3://dodbrian/wg-test/; done
