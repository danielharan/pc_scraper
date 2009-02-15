require 'rubygems'
require 'activesupport'
require 'thor'
require File.dirname(__FILE__) + '/cbc_scraper'

class Scraper < Thor
  
  desc 'spider data_file scraper_class', 'load a data_file and scrape data for each line'
  method_options :pause_min => 1, :pause_max => 3
  def spider(data_file, spider_class)
    class_constant_for(spider_class).spider(data_file) do
      sleep random_interval_between(options[:pause_min],options[:pause_max])
    end
  end
  
  desc 'extract scraper_class', 'extract data from cached files, and write results to standard out'
  def extract(spider_class, data_file)
    puts '{'
    class_constant_for(spider_class).extract(data_file) do |data|
      puts "\"#{data.first}\": #{data.last.inspect}"
    end
    puts '}'
  end
  
  private
    def class_constant_for(class_name)
      class_name.classify.constantize
    end
    
    def random_interval_between(min,max)
      min + (rand((max - min) * 1_000.0) / 1_000.0)
    end
end
