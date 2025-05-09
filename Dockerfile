FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy and make the wrapper script executable
COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

# Use the wrapper script as the entrypoint
CMD ["./run_bot.sh"]
