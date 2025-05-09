FROM python:3.11-slim

WORKDIR /app

# Pre-configure environment before any Python packages install
ENV OMP_NUM_THREADS=1
ENV ONNXRUNTIME_DISABLE_CPU_AFFINITY=1


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY run_bot.sh /app/run_bot.sh
RUN chmod +x /app/run_bot.sh

# Direct execution with auto-update
CMD ["python", "main.py", "--autoupdate"]
CMD ["./run_bot.sh"]
