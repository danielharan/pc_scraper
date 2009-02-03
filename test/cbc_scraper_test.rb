require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../cbc_scraper'

class ScraperTest < Test::Unit::TestCase
  context "A new scraper instance" do
    setup do
      @scraper = CbcScraper.new('G0C 2Y0')
      @url     = 'http://www.cbc.ca/news/canadavotes/myriding/postalcodes/g/g0c/2y0.html'
    end
    
    expect { assert_equal 'G0C2Y0', @scraper.filename }
    
    should "be able to construct the target url" do
      assert_equal @url, @scraper.url
    end
    
    should "return the page body" do
      @scraper.postal_code = "R2W 4B2" # argh, stupid encoding, we use this one for now
      assert_equal '[{"rid":225,"name":"Winnipeg North"}]', @scraper.fetch.strip
    end
    
    should "handle accents gracefully" do
      flunk
    end
  end
end