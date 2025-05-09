FROM python:3.11-slim

WORKDIR /app

# 1. Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    libnuma1 \
    && rm -rf /var/lib/apt/lists/*

# 2. Configure environment to silence affinity warnings
ENV OMP_NUM_THREADS=4 \
    OMP_WAIT_POLICY=PASSIVE \
    KMP_AFFINITY=disabled \
    KMP_DISABLE_THREAD_AFFINITY=TRUE \
    ONNXRT_DISABLE_THREAD_AFFINITY=TRUE \
    TF_CPP_MIN_LOG_LEVEL=3
    
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh


CMD ["./run_bot.sh"]
