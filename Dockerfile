FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    chromium \
    libgl1 \
    libglib2.0-0 \
    libnss3 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxrandr2 \
    libxtst6 \
    libxss1 \
    libasound2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

ENV PORT=8080
ENV BROWSER_HEADLESS=1
ENV SOLVER_PUBLIC_URL=https://captcha-solver-production-a6cd.up.railway.app

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

CMD ["python", "server.py"]
