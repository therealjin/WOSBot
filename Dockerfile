FROM python:3.11-slim

WORKDIR /app

# 1. Install system dependencies with optimized math libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    libnuma1 \
    intel-mkl-2020.3-304 \
    && rm -rf /var/lib/apt/lists/*

# 2. Nuclear environment configuration
ENV OMP_NUM_THREADS=4 \
    OMP_WAIT_POLICY=PASSIVE \
    KMP_AFFINITY=disabled \
    KMP_DISABLE_THREAD_AFFINITY=TRUE \
    ONNXRT_DISABLE_THREAD_AFFINITY=TRUE \
    TF_CPP_MIN_LOG_LEVEL=3 \
    OPENBLAS_NUM_THREADS=1 \
    MKL_NUM_THREADS=1 \
    NUMEXPR_NUM_THREADS=1 \
    VECLIB_MAXIMUM_THREADS=1

# 3. Preload optimized libraries
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libgomp.so.1:/usr/lib/x86_64-linux-gnu/libmkl_rt.so

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 4. Create a pre-execution script
RUN printf '#!/bin/sh\n\
export GOMP_CPU_AFFINITY="0"\n\
exec "$@"\n' > /pre_exec.sh && chmod +x /pre_exec.sh

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

# 5. Chain execution through pre_exec.sh
CMD ["/pre_exec.sh", "/app/run_bot.sh"]
