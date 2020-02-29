#!/bin/sh

sudo apt update -y
sudo apt upgrade -y
/bin/echo Asia/Bangkok > /etc/timezone
/bin/rm /etc/localtime
/bin/ln -s /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
/bin/echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
/bin/echo th_TH.UTF-8 UTF-8 >> /etc/locale.gen
/usr/sbin/locale-gen
sudo apt install vim screenfetch inxi -y
echo "updated system"

sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python -y
echo "installed webmin prerequisites"

wget http://prdownloads.sourceforge.net/webadmin/webmin_1.940_all.deb

sudo dpkg --install webmin_1.940_all.deb

echo "webmin (should be) installed"

sudo apt-get remove docker docker-engine docker.io -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get install docker-ce -y
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo systemctl restart docker
sudo systemctl daemon-reload
echo "installed Docker"

sudo apt install docker-compose -y
echo "installed Docker compose"

mkdir /home/pi/dockerdata

docker volume create portainer_data
docker run --name portainer -p 9000:9000 -p 8000:8000 --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer

curl -LO https://github.com/VSCodium/vscodium/releases/download/1.42.1/codium_1.42.1-1581652067_armhf.deb
sudo apt install ./codium_1.42.1-1581652067_armhf.deb

sudo reboot




