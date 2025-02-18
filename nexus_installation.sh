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
sudo apt install -y pkg-config libssl-dev build-essential nano

# Установка Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Установка Nexus
curl https://cli.nexus.xyz/ | sh


echo "Откройте файл ~/.nexus/prover-id и добавьте ваш prover-id."


echo "Установка завершена. Если нода не запрашивала prover-id, откройте файл ~/.nexus/prover-id и добавьте его вручную."
