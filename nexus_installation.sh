#!/bin/bash
# Цветовые коды
NEON_RED='\033[38;5;196m'
NEON_BLUE='\033[38;5;45m'
RESET='\033[0m'

# Логотип
logo() {
    echo -e "
${NEON_RED}  ____   ${NEON_BLUE}____  
${NEON_RED} |  _ \\  ${NEON_BLUE}|  _ \\ 
${NEON_RED} | | | | ${NEON_BLUE}| |_) |
${NEON_RED} | |_| | ${NEON_BLUE}|  __/ 
${NEON_RED} |____/  ${NEON_BLUE}|_|    
${RESET}
"
}

# Вызов логотипа
logo
echo -e "${NEON_BLUE}https://t.me/DropPredator${RESET}"
# Основная логика
echo -e "${NEON_RED}Welcome to DP Script!${RESET}"

# Обновление пакетов
sudo apt update

# Установка необходимых зависимостей
sudo apt update && sudo apt upgrade -y && \
sudo apt install -y tmux nano build-essential pkg-config libssl-dev git-all unzip && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
source $HOME/.cargo/env && \
rustup target add riscv32i-unknown-none-elf && \
sudo apt remove -y protobuf-compiler && \
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip && \
unzip protoc-25.2-linux-x86_64.zip -d $HOME/.local && \
export PATH="$HOME/.local/bin:$PATH"

sleep 10
# Установка Nexus
screen -dmS nexus bash -c "curl https://cli.nexus.xyz/ | sh"

echo "Для дальнейшей установки используйте следующую команду"
echo "screen -r nexus"

echo "Как зафиксируете, что всё работает используйте сочитание клавишь CNRT + A, D"

echo "Подписуйтесь на канал автора скрипта - t.me/DropPredator "

