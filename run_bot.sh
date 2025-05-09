#!/bin/bash

# Check if BOT_TOKEN is set
if [ -z "$BOT_TOKEN" ]; then
  echo "Error: BOT_TOKEN environment variable is not set."
  exit 1
fi

# Run the bot with autoupdate flag and pass only the token
python3 main.py --autoupdate "$BOT_TOKEN"
