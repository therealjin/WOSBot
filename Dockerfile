FROM python:3.11-slim

WORKDIR /app

# Pre-configure environment before any Python packages install
ENV OMP_NUM_THREADS=4 \
    OMP_WAIT_POLICY=PASSIVE \
    KMP_AFFINITY=disabled \
    TF_CPP_MIN_LOG_LEVEL=3 \
    ONNXRT_DISABLE_THREAD_AFFINITY=1 \
    ONNXRUNTIME_DISABLE_CPU_AFFINITY=1 \
    OPENBLAS_NUM_THREADS=1

# Install critical low-level dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    libnuma1 \
    && rm -rf /var/lib/apt/lists/*


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

CMD ["./run_bot.sh"]
