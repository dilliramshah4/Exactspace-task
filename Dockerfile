# Stage 1: Node.js scraper
FROM node:18-slim AS scraper

RUN groupadd -r appuser && \
    useradd -r -g appuser -d /app -s /sbin/nologin appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app

WORKDIR /app

RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libgtk-3-0 \
    libnss3 \
    libxss1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

COPY package*.json .
RUN npm install --production --no-audit --no-fund

COPY scrape.js .

# Stage 2: Python server
FROM python:3.10-slim AS server

RUN groupadd -r appuser && \
    useradd -r -g appuser -d /app -s /sbin/nologin appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY server.py .

# Final stage
FROM python:3.10-slim

RUN apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    chromium \
    libgtk-3-0 \
    libnss3 \
    libxss1 \
    --no-install-recommends && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r appuser && \
    useradd -r -g appuser -d /app -s /sbin/nologin appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app

WORKDIR /app

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_CACHE_DIR=/app/.cache

RUN mkdir -p /app/.cache && \
    chown -R appuser:appuser /app/.cache

COPY --from=scraper --chown=appuser:appuser /app/node_modules /app/node_modules
COPY --from=scraper --chown=appuser:appuser /app/scrape.js /app/scrape.js
COPY --from=server --chown=appuser:appuser /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=server --chown=appuser:appuser /app/server.py /app/server.py

COPY --chown=appuser:appuser entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 5000

USER appuser

ENTRYPOINT ["/app/entrypoint.sh"]