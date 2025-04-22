#!/bin/bash

# Autor: Rui Paiva - www.rpx.pt
# Script para instalar Docker, Docker Compose e Portainer
# Script to install Docker, Docker Compose, and Portainer

# Cores para saída formatada / Colors for formatted output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[1;34m'
NC='\033[0m' # Sem cor / No color

# Armazena os status de cada etapa / Store each step's status
declare -A STATUS

# Cabeçalho / Header
print_title() {
  echo -e "${BLUE}"
  echo "==============================================="
  echo "     INSTALADOR DOCKER + PORTAINER - RPX       "
  echo "           by Rui Paiva - www.rpx.pt           "
  echo "==============================================="
  echo -e "${NC}"
}

# Verifica se o script está a ser executado como root
# Check if the script is being run as root
check_root() {
  if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
  else
    SUDO=""
  fi
}

# Executa e monitora um comando com descrição
# Run and track a command with a description
run_step() {
  local description="$1"
  local command="$2"
  echo -ne "➤ ${description}... "
  eval "$command" &>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ OK${NC}"
    STATUS["$description"]="✅"
  else
    echo -e "${RED}❌ ERRO${NC}"
    STATUS["$description"]="❌"
  fi
}

# Mostra resumo final dos resultados
# Print final summary of results
print_summary() {
  echo -e "\n${BLUE}===== RESUMO DA INSTALAÇÃO / INSTALL SUMMARY =====${NC}"
  for step in "${!STATUS[@]}"; do
    printf "%-50s %s\n" "$step" "${STATUS[$step]}"
  done
  echo -e "\n${GREEN}Script finalizado com sucesso. Visite ${BLUE}www.rpx.pt${NC} para mais soluções!\n"
}

### Execução principal / Main execution ###
print_title
check_root

run_step "Atualizando pacotes do sistema / Updating system packages" "$SUDO apt-get update"
run_step "Instalando dependências / Installing dependencies (ca-certificates, curl)" "$SUDO apt-get install -y ca-certificates curl"

run_step "Criando diretório para chave GPG / Creating directory for GPG key" "$SUDO install -m 0755 -d /etc/apt/keyrings"
run_step "Baixando chave GPG do Docker / Downloading Docker GPG key" "$SUDO curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc"
run_step "Ajustando permissões da chave / Setting key permissions" "$SUDO chmod a+r /etc/apt/keyrings/docker.asc"

run_step "Adicionando repositório do Docker / Adding Docker repository" "echo \
  'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable' | \
  $SUDO tee /etc/apt/sources.list.d/docker.list > /dev/null"

run_step "Atualizando lista de pacotes / Updating package list again" "$SUDO apt-get update"
run_step "Instalando Docker e componentes / Installing Docker and components" "$SUDO apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

run_step "Verificando versão do Docker / Checking Docker version" "docker -v"

run_step "Baixando Docker Compose / Downloading Docker Compose" "wget -q https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64"
run_step "Movendo Docker Compose para /usr/local/bin / Moving Docker Compose" "$SUDO cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose"
run_step "Tornando Docker Compose executável / Making Docker Compose executable" "$SUDO chmod +x /usr/local/bin/docker-compose"
run_step "Verificando versão do Docker Compose / Checking Docker Compose version" "docker-compose --version"

run_step "Criando volume para Portainer / Creating Portainer volume" "$SUDO docker volume create portainer_data"
run_step "Criando container do Portainer / Creating Portainer container" "$SUDO docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest"

print_summary
