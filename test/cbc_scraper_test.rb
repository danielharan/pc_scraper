require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../cbc_scraper'

class CbcScraperScraperTest < Test::Unit::TestCase
  context "A new scraper instance" do
    setup do
      @scraper = CbcScraper.new('G0C 2Y0')
      @url     = 'http://www.cbc.ca/news/canadavotes/myriding/postalcodes/g/g0c/2y0.html'
    end
    
    expect { assert_equal 'spidered/G0C/G0C2Y0', @scraper.filename }
    
    should "know how to canonicalize its key" do
      assert_equal 'G0C2Y0', @scraper.canonical_key
    end
    
    should "handle accents gracefully" do
      flunk
    end
  end
  
  context "spidering data" do
    setup do
      @scraper = CbcScraper.new('R2W 4B2')
    end
    
    should "be able to construct the target url" do
      assert_equal 'http://www.cbc.ca/news/canadavotes/myriding/postalcodes/r/r2w/4b2.html', @scraper.url
    end
    
    should "return the page body" do
      assert_equal '[{"rid":225,"name":"Winnipeg North"}]', @scraper.fetch.strip
    end
  end
  
  context "extracting data" do
    setup do
      @scraper = CbcScraper.new('G0C 2Y0')
    end
    
    should "extract its riding id" do
      assert_equal 52, @scraper.extract
    end
  end
end