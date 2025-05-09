FROM python:3.11-slim

WORKDIR /app

# Configure ONNX Runtime environment (no additional system packages needed)
# Set all environment variables in proper Dockerfile syntax
ENV OMP_NUM_THREADS=4
ENV OMP_WAIT_POLICY=PASSIVE
ENV KMP_AFFINITY=none
ENV OMP_DISABLE_AFFINITY=TRUE

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy and make the wrapper script executable
COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

CMD ["./run_bot.sh"]  
