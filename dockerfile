FROM python:3.11-slim

WORKDIR /app

# Install Chromium, Xvfb, dan semua dependencies sistem yang dibutuhkan
RUN apt-get update && apt-get install -y \
    xvfb \
    chromium \
    chromium-driver \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libnss3 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libgdk-pixbuf2.0-0 \
    libxshmfence1 \
    libxfixes3 \
    libxrender1 \
    libxss1 \
    libxv1 \
    libxcb-shm0 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libxcb-randr0 \
    libxcb-render0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-util1 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0 \
    libxkbcommon0 \
    libdrm2 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libwebp7 \
    libwebpdemux2 \
    libwebpmux3 \
    libxslt1.1 \
    libxml2 \
    libopus0 \
    libvpx7 \
    libavcodec58 \
    libavformat58 \
    libswscale5 \
    libavutil56 \
    libpulse0 \
    libcups2 \
    libdbus-1-3 \
    libgssapi-krb5-2 \
    libkrb5-3 \
    libcurl4 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV BROWSER_HEADLESS=0
ENV PORT=8877
ENV PYTHONUNBUFFERED=1
# Optional: set chromium path if needed (usually /usr/bin/chromium)
ENV CHROME_PATH=/usr/bin/chromium

# Copy requirements first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all source code
COPY . .

EXPOSE 8877

CMD xvfb-run -a --server-args="-screen 0 1920x1080x24" python3 server.py
