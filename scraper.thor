require 'rubygems'
require 'thor'
require File.dirname(__FILE__) + '/cbc_scraper'

class Scraper < Thor
  
  def scrape_postal_codes(postal_code_file)
    postal_codes = File.open("postal_codes.txt").read.split("\n")
    # randomize to make the pattern slightly harder to see in logs
    postal_codes = postal_codes.sort_by {|e| rand(10_000)}

    postal_codes.each do |pc|
      begin
        scraper  = CbcScraper.new(pc)
        filename = './pages/' + scraper.filename
        next if File.exists?(filename)

        puts "going to write to #{filename}"
        File.open(filename, "w") do |f|
          f.puts scraper.fetch
        end
      sleep random_interval_between(1,3)
      rescue Exception => e
        puts "could not fetch #{pc}, sleeping for a bit (exception was #{e}"
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
