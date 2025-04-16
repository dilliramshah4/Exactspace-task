
A Dockerized application that uses Python/Flask to serve the scraped data as JSON and Node.js/Puppeteer for web scraping.

## Prerequisites

- Docker 
- Git
- Bash shell


## Installation Guide:-

# Clone repository
```sh
git clone https://github.com/dilliramshah4/Exactspace-task.git
```
# Move into the project directory
```sh
cd Exactspace-task
```


# Build the Docker image
```sh
sudo docker build --no-cache -t web-scraper .
```


#  Scraping 
```sh
sudo docker run -p 5000:5000 -e SCRAPE_URL="https://example.com" web-scraper
```
#  Example Websites
```sh
docker run -p 5000:5000 -e SCRAPE_URL="https://react.dev" web-scraper
```
# Access Data
```sh
curl http://localhost:5000
```
![Screenshot from 2025-04-16 22-09-14](https://github.com/user-attachments/assets/9ef1e90a-24ef-4223-8460-ed3c99d4eb23)

# Through Browser

```sh
http://localhost:5000
```
![Screenshot from 2025-04-16 22-06-42](https://github.com/user-attachments/assets/7db23a35-a5a1-4172-97e7-42caca1eafb2)

#  Example Websites
```sh
docker run -p 5000:5000 -e SCRAPE_URL="https://en.wikipedia.org/wiki/DevOps" web-scraper
```
# Access Data

![Screenshot from 2025-04-16 22-42-48](https://github.com/user-attachments/assets/a89f3a24-133e-421e-adb5-2635d5bb1d38)

## Troubleshooting
Common Errors

- **"node: not found"**  
  Rebuild the Docker image without using cache:  
  ```bash
  docker build --no-cache -t web-scraper .

## Permission denied
```bash
chmod +x entrypoint.sh
```


