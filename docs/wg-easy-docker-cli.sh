docker run -d \
  --name=wg-easy \
  -e WG_HOST=13.50.22.34 \
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
  
  
while true; do
	"/root/.wg-easy/wg0.json" | entr -d cp /root/.wg-easy/wg0.json /root 
done


while true; do echo "/root/.wg-easy/wg0.json" | sudo entr -d cp /root/.wg-easy/wg0.json /root; done

sudo yum remove awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo yum install -y amazon-linux-extras

