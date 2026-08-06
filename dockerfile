# Gunakan Python 3.11 slim (ringan)
FROM python:3.11-slim

# Set working directory di dalam container
WORKDIR /app

# Install system dependencies:
# - xvfb       : virtual display untuk headed browser
# - chromium   : browser yang dipakai oleh cloakbrowser
# - libgl1-mesa-glx, libglib2.0-0 : wajib untuk opencv-python-headless
# - wget, gnupg : (optional) kalau dibutuhkan nanti
RUN apt-get update && apt-get install -y \
    xvfb \
    chromium \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables yang dibaca oleh server.py dan solver
ENV BROWSER_HEADLESS=0
ENV PORT=8877
ENV PYTHONUNBUFFERED=1

# Copy file requirements terlebih dahulu (agar Docker bisa cache layer ini)
COPY requirements.txt .

# Install semua dependensi Python
RUN pip install --no-cache-dir -r requirements.txt

# Copy semua kode sumber (server.py, folder turnstile/, recaptcha/, dll.)
COPY . .

# Expose port 8877
EXPOSE 8877

# Perintah startup:
# - jalankan xvfb-run (buat virtual display)
# - jalankan server.py langsung (tanpa uvicorn main:app)
CMD xvfb-run -a --server-args="-screen 0 1920x1080x24" python3 server.py
