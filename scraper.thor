require 'rubygems'
require 'activesupport'
require 'thor'
require File.dirname(__FILE__) + '/cbc_scraper'

class Scraper < Thor
  
  desc 'scrape data_file scraper_class', 'load a data_file and scrape data for each line'
  method_options :pause_min => 1, :pause_max => 3
  def scrape(data_file, scraper_class)
    puts options.inspect
    scraper_class = scraper_class.classify.constantize
    # randomize to make the pattern slightly harder to see in logs
    data = File.read(data_file).map {|l| l.chomp}.sort_by {|e| rand(10_000)}
    
    data.each do |datum|
      begin
        scraper  = CbcScraper.new(datum)
        
        unless File.exists?(scraper.filename)
          File.open(scraper.filename, "w") {|f| f.puts scraper.fetch }
          
          sleep random_interval_between(options[:pause_min],options[:pause_max])
        end
      rescue Exception => e
        puts "could not fetch #{datum}, sleeping for a bit (exception was #{e}"
        sleep 20
        next
      end
    end
  end
  
  protected
    def random_interval_between(min,max)
      min + (rand((max - min) * 1_000.0) / 1_000.0)
    end
end
