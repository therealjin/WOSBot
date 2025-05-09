FROM python:3.11-slim

WORKDIR /app

# 1. Install only necessary system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    libnuma1 \
    && rm -rf /var/lib/apt/lists/*

# 2. Comprehensive thread control
ENV OMP_NUM_THREADS=4 \
    OMP_WAIT_POLICY=PASSIVE \
    KMP_AFFINITY=disabled \
    KMP_DISABLE_THREAD_AFFINITY=TRUE \
    ONNXRT_DISABLE_THREAD_AFFINITY=TRUE \
    TF_CPP_MIN_LOG_LEVEL=3 \
    OPENBLAS_NUM_THREADS=1 \
    MKL_NUM_THREADS=1 \
    NUMEXPR_NUM_THREADS=1

# 3. Force-disable affinity at lowest level
RUN printf '#!/bin/sh\nexport GOMP_CPU_AFFINITY="0"\nexport OMP_DISPLAY_AFFINITY=FALSE\nexec "$@"\n' > /pre_exec.sh \
    && chmod +x /pre_exec.sh

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

CMD ["/pre_exec.sh", "/app/run_bot.sh"]
