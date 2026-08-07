# Gunakan image Python dengan Chromium terinstal
FROM python:3.10-slim

# Install Chromium, Xvfb, dan dependensi sistem
RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
    libgl1-mesa-glx \
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

# Set environment variables
ENV PORT=8877
ENV BROWSER_HEADLESS=0
ENV SOLVER_PUBLIC_URL=https://your-railway-app.railway.app

# Buat direktori kerja
WORKDIR /app

# Copy file proyek
COPY . .

# Install dependensi Python
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8877

# Jalankan dengan xvfb-run
CMD ["xvfb-run", "-a", "--server-args=-screen 0 1920x1080x24", "python", "server.py"]
