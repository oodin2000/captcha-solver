# Gunakan image Python dengan Chromium terinstal
FROM python:3.10-slim

# Install Chromium, Xvfb, dan dependensi sistem
RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
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
    && rm -rf /var/lib/apt/lists/*

# Set environment variables (PORT disesuaikan dengan default Railway)
ENV PORT=8080
ENV BROWSER_HEADLESS=0
ENV SOLVER_PUBLIC_URL=https://your-railway-app.railway.app

# Buat direktori kerja
WORKDIR /app

# Copy file proyek (kecuali yang di .dockerignore)
COPY . .

# Install dependensi Python dari requirements.txt yang sudah benar
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080 (sesuai dengan ENV PORT)
EXPOSE 8080

# Jalankan dengan xvfb-run (headed mode)
CMD ["xvfb-run", "-a", "--server-args=-screen 0 1920x1080x24", "python", "server.py"]
