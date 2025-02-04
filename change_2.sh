#!/bin/bash

# Step 1: Get Node ID
NODE_INFO=$(gaianet info --base "$HOME/gaianet-2")
NODE_ID=$(echo "$NODE_INFO" | grep 'Node ID:' | awk '{print $3}')

# Step 2: Delete the existing Python script if it exists
rm -rf random_chat_with_faker_2.py

# Step 3: Create a new Python script with the Node ID
cat <<EOF > random_chat_with_faker_2.py
import requests
import random
import logging
import time
from faker import Faker
from datetime import datetime

node_url = "https://${NODE_ID}.gaia.domains/v1/chat/completions"

faker = Faker()

headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
}

logging.basicConfig(filename='chat_log.txt', level=logging.INFO, format='%(asctime)s - %(message)s')

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

    delay = random.randint(1, 3)
    time.sleep(delay)
EOF

# Step 4: Kill existing screen session if it exists
if screen -list | grep -q "faker_session_2"; then
    screen -S faker_session_2 -X quit
fi

# Step 5: Run the script in a new screen session
screen -dmS faker_session_2 python3 random_chat_with_faker_2.py

echo "Script has been updated and is now running in a new screen session: faker_session_2"
