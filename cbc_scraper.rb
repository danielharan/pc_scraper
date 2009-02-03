require 'rubygems'
require 'open-uri'

class CbcScraper
  attr_accessor :postal_code
  def initialize(postal_code)
    @postal_code = postal_code
  end
  
  def filename
    @postal_code.gsub(' ', '')
  end
  
  def url
    fsa, ldu = @postal_code.split(' ').collect {|e| e.downcase }
    "http://www.cbc.ca/news/canadavotes/myriding/postalcodes/#{postal_code[0..0].downcase}/#{fsa}/#{ldu}.html"
  end
  
  def fetch
    open(url).read
  end
end