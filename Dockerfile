FROM python:3.11-slim

WORKDIR /app

# 1. Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# 2. Nuclear environment configuration
ENV OMP_NUM_THREADS=1 \
    OMP_WAIT_POLICY=PASSIVE \
    KMP_AFFINITY=disabled \
    KMP_DISABLE_THREAD_AFFINITY=TRUE \
    ONNXRT_DISABLE_THREAD_AFFINITY=TRUE \
    TF_CPP_MIN_LOG_LEVEL=3 \
    OPENBLAS_NUM_THREADS=1 \
    MKL_NUM_THREADS=1 \
    NUMEXPR_NUM_THREADS=1 \
    VECLIB_MAXIMUM_THREADS=1

# 3. Force single-threaded execution at system level
RUN printf '#!/bin/sh\n\
taskset -c 0 python "$@"\n' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

# 4. Chain execution through forced single-core
CMD ["/entrypoint.sh", "/app/run_bot.sh"]
