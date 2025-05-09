#!/bin/bash
#!/bin/bash

# Check if BOT_TOKEN is set
if [ -z "$BOT_TOKEN" ]; then
  echo "Error: BOT_TOKEN environment variable is not set."
  exit 1
fi

# Run with auto-update and pass token via stdin
printf "%s\ny" "$BOT_TOKEN" | python3 main.py --autoupdate
