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

# Prompt the user to input the domain name
read -p "Enter your domain name: " DOMAIN

# Prompt the user to input the number of sessions
read -p "How many screen sessions do you want to start? " NUM_SESSIONS

# Validate the input: check if it's a positive integer
if ! [[ "$NUM_SESSIONS" =~ ^[0-9]+$ ]] || [ "$NUM_SESSIONS" -le 0 ]; then
  echo "Please enter a valid positive number."
  exit 1
fi

# Path to the Python script
SCRIPT_PATH="autochat_with_gaia.py"

# Check if the Python script exists
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Creating $SCRIPT_PATH..."
  cat > "$SCRIPT_PATH" <<EOF
import requests
import random
import logging
import time
from faker import Faker
from datetime import datetime

node_url = "https://$DOMAIN.gaia.domains/v1/chat/completions"

faker = Faker()

headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
}

logging.basicConfig(filename='chat_log_2.txt', level=logging.INFO, format='%(asctime)s - %(message)s')

def log_message(node, message):
    logging.info(f"{node}: {message}")

def send_message(node_url, message):
    try:
        response = requests.post(node_url, json=message, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Failed to get response from API: {e}")
        return None

def extract_reply(response):
    if response and 'choices' in response:
        return response['choices'][0]['message']['content']
    return ""

while True:
    random_question = faker.sentence(nb_words=10)
    message = {
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": random_question}
        ]
    }

    question_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    response = send_message(node_url, message)
    reply = extract_reply(response)

    reply_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    log_message("Node replied", f"Q ({question_time}): {random_question} A ({reply_time}): {reply}")

    print(f"Q ({question_time}): {random_question}\nA ({reply_time}): {reply}")

    delay = random.randint(0, 1)
    time.sleep(delay)
EOF
fi


# Create the specified number of screen sessions
for ((i = 1; i <= NUM_SESSIONS; i++))

do
  SESSION_NAME="chat_session_$i"
  sleep 30
  echo "Creating screen session: $SESSION_NAME"

  # Start a detached screen session running the Python script
  screen -dmS "$SESSION_NAME" bash -c "python3 $SCRIPT_PATH $DOMAIN"
done

echo "All $NUM_SESSIONS screen sessions have been created."






