sudo apt-get update
apt-get install apt-transport-https ca-certificates software-properties-common
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
echo "deb https://download.docker.com/linux/raspbian/ stretch stable" > /etc/apt/sources.list.d/docker.list
apt install --no-install-recommends docker-ce
systemctl enable docker.service
systemctl start docker.service