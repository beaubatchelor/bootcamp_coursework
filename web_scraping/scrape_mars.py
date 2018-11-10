from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
import time

def init_browser():
        executable_path = {"executable_path": "C:\Program Files (x86)\Google\chromedriver"}
        return Browser("chrome", **executable_path, headless = True)


# Function that uses a json with html class as key and html tag as value to scrape a url.
def scrape_first(url, dicti, tags_class_dict):
    browser = init_browser()
    browser.visit(str(url))
    time.sleep(1)
    html = browser.html
    soup = BeautifulSoup(html, "lxml")
    
    for key, value in tags_class_dict.items():
        dicti[key.replace(" ", "_")] = soup.find(value, class_= key).get_text()
        try:
            dicti[key.replace(" ", "_")+"_Style"] = soup.find(value, class_= key)['style']
        except:
            dicti[key.replace(" ", "_")+"_Style"] = "Not Available"
    browser.quit()
    
    return dicti


def scrape():
    scraped_dict = {}

    # News about Mars scrape info
    mars_news = {}
    news_url = "https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest"
    news_dict = {"content_title" : "div", "article_teaser_body" : "div"}
        
    scrape_first(news_url, mars_news, news_dict)
    
    scraped_dict.update(mars_news)

    # Image of Jpl scrape info
    mars_image = {}
    featured_image_url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    image_dict = {"carousel_item" : "article"}

    scrape_first(featured_image_url, mars_image, image_dict)

    jpg_img_path = mars_image["carousel_item_Style"][slice(23,-3,1)]
    featured_image_url = "https://www.jpl.nasa.gov"+jpg_img_path

    scraped_dict['featured_image_url'] = featured_image_url

    # Weather of Mars scrape info
    mars_weather = {}
    weather_url = "https://twitter.com/marswxreport?lang=en"
    weather_dict = {"TweetTextSize TweetTextSize--normal js-tweet-text tweet-text" : "p"}

    scrape_first(weather_url, mars_weather, weather_dict)

    mars_weather = mars_weather['TweetTextSize_TweetTextSize--normal_js-tweet-text_tweet-text']
    
    scraped_dict["mars_weather"] = mars_weather

    facts_url = "https://space-facts.com/mars/"

    tabels_facts_url = pd.read_html(facts_url)

    facts_df = tabels_facts_url[0]
    facts_df.columns = ['info', 'info_values']
    facts_df = facts_df.to_dict('records')

    scraped_dict["facts_df"] = facts_df

    # Find all titles of hemispheres
    hemi_url = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
    browser = init_browser()
    browser.visit(str(hemi_url))
    html = browser.html
    soup = BeautifulSoup(html, "lxml")
    titles = soup.find_all("h3")
    browser.quit()

    # Find all pictures of hemispheres
    hemisphere_image_urls = []
    for title in titles:
        data = {}
        titl = title.text
        data['title'] = titl
        titl = titl.replace(" ", "_")
        titl = titl.replace("_Hemisphere", "")
        titl = titl.lower()
        data['img_url'] = f"https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/{titl}.tif/full.jpg"
        hemisphere_image_urls.append(data)

    scraped_dict["hemisphere_image_urls"] = hemisphere_image_urls

    return scraped_dict
