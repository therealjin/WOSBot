#!/bin/bash

# Check if BOT_TOKEN is set
if [ -z "$BOT_TOKEN" ]; then
  echo "Error: BOT_TOKEN environment variable is not set."
  exit 1
fi

# Run the bot and pass the token and 'y' as input using a here document
python3 main.py <<EOF
$BOT_TOKEN
y
EOF
