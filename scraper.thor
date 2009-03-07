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
  
  desc 'extract scraper_class data_file', 'extract data from cached files, and write results to standard out'
  def extract(spider_class, data_file)
    class_constant_for(spider_class).extract(data_file) do |data|
      data.last.each do |riding_id|
        puts "#{data.first},#{riding_id}"
      end
    end
  end
  
  desc 'extract_riding_ids_and_names', 'extract a hash or riding ids and names'
  def extract_riding_ids_and_names(spider_class, data_file)
    hash = {}
    class_constant_for(spider_class).extract_riding_id_and_names(data_file) do |key,val|
      hash[key] = val
    end
    puts hash.inspect
  end
  
  private
    def class_constant_for(class_name)
      class_name.classify.constantize
    end
    
    def random_interval_between(min,max)
      min + (rand((max - min) * 1_000.0) / 1_000.0)
    end
end
