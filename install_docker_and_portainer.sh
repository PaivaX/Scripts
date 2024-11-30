#!/bin/bash

# Verifica se o script está sendo executado como root
# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

# Atualiza o sistema e instala dependências
# Update the system and install dependencies
$SUDO apt-get update
$SUDO apt-get install -y ca-certificates curl

# Configura o diretório para armazenar a chave GPG
# Set up the directory to store the GPG key
$SUDO install -m 0755 -d /etc/apt/keyrings

# Baixa a chave GPG oficial do Docker
# Download the official Docker GPG key
$SUDO curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
$SUDO chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório do Docker ao sources.list
# Add Docker repository to sources.list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  $SUDO tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza a lista de pacotes
# Update the package list
$SUDO apt-get update

# Instala o Docker e seus componentes
# Install Docker and its components
$SUDO apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verifica a versão do Docker
# Check Docker version
docker -v
echo
echo -e "\e[32mDocker instalado com sucesso!\e[0m" # Docker successfully installed!
echo

# Instala o Docker Compose
# Install Docker Compose
wget https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64
$SUDO cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose
$SUDO chmod +x /usr/local/bin/docker-compose

# Verifica a versão do Docker Compose
# Check Docker Compose version
docker-compose --version
echo
echo -e "\e[32mDocker Compose instalado com sucesso!\e[0m" # Docker Compose successfully installed!
echo

# Cria volume para Portainer
# Create volume for Portainer
$SUDO docker volume create portainer_data

# Cria o container do Portainer
# Create the Portainer container
$SUDO docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
echo
echo -e "\e[32mDocker e Portainer instalados com sucesso! - By Rui Paiva\e[0m" # Docker and Portainer successfully installed!
