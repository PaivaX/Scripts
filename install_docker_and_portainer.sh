# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install last version of docker
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check version
docker -v
echo
echo -e "\e[32mDocker instalado com sucesso!\e[0m"
echo

# Install Docker Compose
wget https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64

sudo cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# Check version of docker-compose
sudo docker-compose --version
echo
echo -e "\e[32mdocker-compose instalado com sucesso!\e[0m"
echo

# Create volume for Portainer
sudo docker volume create portainer_data

# Create container of Portainer
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
echo
echo -e "\e[32mDocker e Portainer  instalados com sucesso! - By Rui Paiva\e[0m"
