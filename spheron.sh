#!/bin/bash

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

# Отображаем логотип
curl -s https://raw.githubusercontent.com/noxuspace/cryptofortochka/main/logo_club.sh | bash

# Меню
echo -e "${YELLOW}Выберите действие:${NC}"
echo -e "${CYAN}1) Установка ноды${NC}"
echo -e "${CYAN}2) Проверка логов${NC}"
echo -e "${CYAN}3) Удаление ноды${NC}"

echo -e "${YELLOW}Введите номер:${NC} "
read choice

case $choice in
    1)
        echo -e "${BLUE}Устанавливаем ноду Spheron...${NC}"

        # Обновление системы и установка зависимостей
        sudo apt update -y && sudo apt upgrade -y
        
        # Проверка и установка Docker
        if ! command -v docker &> /dev/null; then
            echo "Docker не установлен. Устанавливаю Docker..."
            sudo apt-get install -y ca-certificates curl gnupg
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            sudo chmod a+r /etc/apt/keyrings/docker.gpg
        
            echo "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
            sudo apt update -y
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        else
            echo "Docker уже установлен. Пропускаю установку."
        fi
        
        # Проверка и установка Docker Compose
        if ! command -v docker-compose &> /dev/null; then
            echo "Docker Compose не установлен. Устанавливаю Docker Compose..."
            sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
        else
            echo "Docker Compose уже установлен. Пропускаю установку."
        fi
        
        # Проверка успешной установки
        if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
            echo "Docker и Docker Compose успешно установлены и готовы к использованию."
        else
            echo "Ошибка при установке Docker или Docker Compose. Проверьте журнал ошибок."
        fi

        # Проверка домашней директории
        HOME_DIR=$(eval echo ~$USER)

        # Выдаем права на скачанный скрипт
        chmod +x "$HOME_DIR/fizzup.sh"

        # Запускаем скрипт
        "$HOME_DIR/fizzup.sh"

        # Заключительный вывод
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${YELLOW}Команда для проверки логов:${NC}"
        echo "sphnctl fizz logs"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
        echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
        sleep 2
        ;;
    
    2)
        # Проверка логов
        sphnctl fizz logs
        ;;
    3)
        echo -e "${BLUE}Удаление ноды Spheron...${NC}"

        # Остановка компоуза
        docker-compose -f ~/.spheron/fizz/docker-compose.yml down
        sleep 3

        # Удаление папки и скрипта
        rm -rf ~/.spheron
        rm -f "$HOME_DIR/fizzup.sh"

        echo -e "${GREEN}Нода Spheron успешно удалена!${NC}"

        # Заключительный вывод
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
        echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
        sleep 1
        ;;
    *)
        echo -e "${RED}Неверный выбор. Пожалуйста, введите номер от 1 до 4.${NC}"
        ;;
esac
