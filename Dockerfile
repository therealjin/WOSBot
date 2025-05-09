FROM python:3.11-slim

WORKDIR /app

# Only essential environment variables
ENV OMP_NUM_THREADS=4 \
    OMP_WAIT_POLICY=PASSIVE \
    KMP_AFFINITY=none \
    ONNXRT_DISABLE_THREAD_AFFINITY=TRUE 

# Install libgomp via apt 
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

CMD ["./run_bot.sh"]
