#!/bin/bash

BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "  _______ _ _                 ______    _"            
    echo " |__   __(_) |               |  ____|  | |"           
    echo "    | |   _| |_ __ _ _ __    | |__   __| | __ _  ___" 
    echo "    | |  | | __/ _\` | '_ \   |  __| / _\` |/ _\` |/ _ \\"
    echo "    | |  | | || (_| | | | |  | |___| (_| | (_| |  __/"
    echo "    |_|  |_|\__\__,_|_| |_|  |______\__,_|\__, |\___|"
    echo "                                            __/ |"     
    echo "                                           |___/"      
    echo
    echo "                Titan Edge Installer v1.0"
    echo "                Author: Galkurta"
    echo -e "${NC}\n"
}

print_msg() {
    echo -e "  ${BLUE}→${NC} $1"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "  ${RED}×${NC} $1"
    exit 1
}

print_progress() {
    echo -e "  ${BLUE}→${NC} $1 ${GREEN}[$2%]${NC}"
}

generate_node_name() {
    local base_name="titannode"
    local counter=1

    # Check existing Docker containers and increment the counter
    while docker ps -a --format '{{.Names}}' | grep -qw "${base_name}_${counter}"; do
        counter=$((counter + 1))
    done

    echo "${base_name}_${counter}"
}

install_docker() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    else
        print_error "Cannot detect OS"
    fi

    case $OS in
        *"Ubuntu"*|*"Debian"*)
            print_progress "Updating package list..." "20"
            sudo apt-get update >/dev/null 2>&1
            
            print_progress "Installing prerequisites..." "40"
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release >/dev/null 2>&1
            
            print_progress "Adding Docker repository..." "60"
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >/dev/null 2>&1
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            print_progress "Installing Docker..." "80"
            sudo apt-get update >/dev/null 2>&1
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io >/dev/null 2>&1
            ;;
        *"CentOS"*|*"Red Hat"*|*"Fedora"*)
            print_progress "Installing prerequisites..." "25"
            sudo yum install -y yum-utils >/dev/null 2>&1
            
            print_progress "Adding Docker repository..." "50"
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >/dev/null 2>&1
            
            print_progress "Installing Docker..." "75"
            sudo yum install -y docker-ce docker-ce-cli containerd.io >/dev/null 2>&1
            ;;
        *)
            print_error "Unsupported operating system: $OS"
            ;;
    esac

    print_progress "Starting Docker service..." "90"
    sudo systemctl start docker >/dev/null 2>&1
    sudo systemctl enable docker >/dev/null 2>&1
    sudo usermod -aG docker $USER >/dev/null 2>&1
    
    print_success "Docker installation completed [100%]"
    echo
}

print_banner

if [ "$EUID" -ne 0 ]; then
    print_error "Please run with sudo privileges"
fi

echo -e "  ${BLUE}Checking system requirements...${NC}"
if ! command -v docker &> /dev/null; then
    print_msg "Docker not found. Starting installation..."
    echo
    install_docker
else
    print_success "Docker already installed"
    echo
fi

while true; do
    echo -en "  ${BLUE}Enter your hash:${NC} "
    read HASH
    if [ ! -z "$HASH" ]; then
        break
    fi
    print_msg "Hash cannot be empty"
done

API_URL="https://api-test1.container1.titannet.io/api/v2/device/binding"

print_msg "Installing Titan Edge..."

print_progress "Pulling Docker image..." "25"
docker pull nezha123/titan-edge >/dev/null 2>&1 || print_error "Failed to pull Docker image"

NODE_NAME=$(generate_node_name)
print_msg "Generated node name: ${NODE_NAME}"

print_progress "Creating directory and starting container..." "50"
mkdir -p ~/.titanedge || print_error "Failed to create directory ~/.titanedge"
chmod 755 ~/.titanedge || print_error "Failed to set permissions for ~/.titanedge"

# Use the generated node name in the container
print_progress "Starting container with name ${NODE_NAME}..." "75"
docker run --name "${NODE_NAME}" --network=host -d \
  -v "$(realpath ~/.titanedge):/root/.titanedge" \
  nezha123/titan-edge >/dev/null 2>&1 || print_error "Failed to start container"

print_progress "Binding device..." "90"
docker run --rm -it \
  -v "$(realpath ~/.titanedge):/root/.titanedge" \
  nezha123/titan-edge bind --hash="$HASH" "$API_URL" || print_error "Failed to bind device. Check hash and try again."

print_success "Installation complete! Titan Edge is now running as ${NODE_NAME}. [100%]"
