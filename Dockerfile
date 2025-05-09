FROM python:3.11-slim

WORKDIR /app

# 1. Install essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# 2. Comprehensive thread control
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

# 3. Create a Python wrapper to disable affinity at runtime
RUN printf 'import os\n\
import sys\n\
from ctypes import CDLL\n\
\n\
try:\n\
    # Disable thread affinity via libgomp\n\
    libgomp = CDLL("libgomp.so.1")\n\
    libgomp.GOMP_cpu_affinity(0, 0)\n\
except:\n\
    pass\n\
\n\
os.execvp("python", ["python"] + sys.argv[1:])\n' > /disable_affinity.py

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

# 4. Use Python wrapper as entry point
CMD ["python", "/disable_affinity.py", "/app/run_bot.sh"]
