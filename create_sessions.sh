#!/bin/bash

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
