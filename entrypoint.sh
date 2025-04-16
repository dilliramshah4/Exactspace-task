#!/bin/sh

# Run scraper
node /app/scrape.js

# Start server if scrape succeeded
if [ -f "/app/scraped_data.json" ]; then
    python /app/server.py
else
    echo "ERROR: Scraping failed! Check logs for details."
    exit 1
fi