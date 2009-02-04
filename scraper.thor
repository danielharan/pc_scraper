require 'rubygems'
require 'activesupport'
require 'thor'
require File.dirname(__FILE__) + '/cbc_scraper'

class Scraper < Thor
  
  desc 'spider data_file scraper_class', 'load a data_file and scrape data for each line'
  method_options :pause_min => 1, :pause_max => 3
  def spider(data_file, spider_class)
    spider_class.classify.constantize.spider(data_file, options)
   end
end
