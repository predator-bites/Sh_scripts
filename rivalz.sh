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
echo -e "${CYAN}2) Обновление ноды${NC}"
echo -e "${CYAN}3) Переход в сессию screen${NC}"
echo -e "${CYAN}4) Удаление ноды${NC}"

echo -e "${YELLOW}Введите номер:${NC} "
read choice

case $choice in
    1)
        echo -e "${BLUE}Устанавливаем ноду Rivalz...${NC}"

        # Обновление и установка необходимых компонентов
        sudo apt update -y
        sudo apt upgrade -y
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt install -y nodejs
        npm i -g rivalz-node-cli
        sudo apt-get update
        sudo apt-get install screen -y

        # Находим все сессии screen, содержащие "rivalz"
        SESSION_IDS=$(screen -ls | grep "rivalz" | awk '{print $1}' | cut -d '.' -f 1)

        # Если сессии найдены, удаляем их
        if [ -n "$SESSION_IDS" ]; then
            echo -e "${BLUE}Завершение сессий screen с идентификаторами: $SESSION_IDS${NC}"
            for SESSION_ID in $SESSION_IDS; do
                screen -S "$SESSION_ID" -X quit
            done
        else
            echo -e "${BLUE}Сессии screen для ноды Rivalz не найдены, создаем сессию...${NC}"
        fi

        # Создание сессии screen
        screen -dmS rivalz

        # Заключительное сообщение
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${YELLOW}Нода запущена в screen-сессии с именем: rivalz${NC}"
        echo -e "${YELLOW}Для перехода в сессию используйте:${NC}"
        echo -e "screen -r rivalz"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
        echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
        ;;
    2)
        echo -e "${BLUE}Обновление ноды Rivalz...${NC}"
        echo -e "${GREEN}Установлена актуальная версия ноды!${NC}"
        ;;
    3)
        echo -e "${BLUE}Переход в сессию screen...${NC}"
        screen -r rivalz
        ;;
    4)
        echo -e "${BLUE}Удаление ноды Rivalz...${NC}"

        # Находим все сессии screen, содержащие "rivalz"
        SESSION_IDS=$(screen -ls | grep "rivalz" | awk '{print $1}' | cut -d '.' -f 1)

        # Если сессии найдены, удаляем их
        if [ -n "$SESSION_IDS" ]; then
            echo -e "${BLUE}Завершение сессий screen с идентификаторами: $SESSION_IDS${NC}"
            for SESSION_ID in $SESSION_IDS; do
                screen -S "$SESSION_ID" -X quit
            done
        else
            echo -e "${BLUE}Сессии screen для ноды Rivalz не найдены, удаление завершено.${NC}"
        fi

        # Заключительное сообщение
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
        echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
        sleep 1
        ;;
    *)
        echo -e "${RED}Неверный выбор. Пожалуйста, выберите номер от 1 до 4.${NC}"
        ;;
esac
