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
# Prompt the user to input the number of sessions
read -p "How many screen sessions do you want to start? " NUM_SESSIONS

# Validate the input: check if it's a positive integer
if ! [[ "$NUM_SESSIONS" =~ ^[0-9]+$ ]] || [ "$NUM_SESSIONS" -le 0 ]; then
  echo "Please enter a valid positive number."
  exit 1
fi

# Path to the Python script
SCRIPT_PATH="random_chat_with_faker.py"

# Check if the Python script exists
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: $SCRIPT_PATH not found!"
  exit 1
fi

# Create the specified number of screen sessions
for ((i = 1; i <= NUM_SESSIONS; i++))
do
  SESSION_NAME="chat_session_$i"
  echo "Creating screen session: $SESSION_NAME"

  # Start a detached screen session running the Python script
  screen -dmS "$SESSION_NAME" bash -c "python3 $SCRIPT_PATH"
done

echo "All $NUM_SESSIONS screen sessions have been created."
