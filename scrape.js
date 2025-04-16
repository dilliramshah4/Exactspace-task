const puppeteer = require('puppeteer');
const fs = require('fs');

async function runScrape(url) {
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();

  try {
    // Scrape logic
    await page.goto(url, { waitUntil: 'domcontentloaded' });
    
    const data = {
      title: await page.title(),
      h1: await page.$eval('h1', el => el.textContent).catch(() => 'No H1 found'),
      status: 'success',
      timestamp: new Date().toISOString()
    };

    fs.writeFileSync('/app/scraped_data.json', JSON.stringify(data));
    
  } finally {
    await browser.close();
  }
}


(async () => {
  try {
    const url = process.env.SCRAPE_URL;
    if (!url) throw new Error('SCRAPE_URL environment variable not set');
    
    await runScrape(url);
    process.exit(0); 
    
  } catch (error) {
    console.error(error);
    
    
    fs.writeFileSync('/app/scraped_data.json', JSON.stringify({
      error: error.message,
      status: 'failed'
    }));
    
    process.exit(1);  
  }
})();