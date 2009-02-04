require 'rubygems'
require 'open-uri'

class CbcScraper
  attr_accessor :postal_code
  def initialize(postal_code)
    @postal_code = postal_code
  end

  def filename
    "spidered/#{fsa}/#{fsa}#{ldu}"
  end
  
  def fsa
    @postal_code.split(' ').first
  end
  
  def ldu
    @postal_code.split(' ').last
  end

  def url
    "http://www.cbc.ca/news/canadavotes/myriding/postalcodes/#{postal_code[0..0].downcase}/#{fsa.downcase}/#{ldu.downcase}.html"
  end

  def fetch
    open(url).read
  end

  #self << class
  
    def self.spider(data_file, options)
      # randomize to make the pattern slightly harder to see in logs
      data = File.read(data_file).map {|l| l.chomp}.sort_by {|e| rand(10_000)}
    
      data.each do |datum|
        begin
          if scrape(datum)
            sleep(random_interval_between(options[:pause_min],options[:pause_max]))
          end
        rescue Exception => e
          # rescuing exception because that gets thrown by open TODO: see if we can catch something saner
          puts "could not fetch #{datum}, sleeping for a bit (exception was #{e}"
          sleep 20
          next
        end
      end
    end
    
    def self.scrape(datum)
      scraper = new(datum)

      if File.exists?(scraper.filename)
        false
      else
        File.open(scraper.filename, "w") {|f| f.puts scraper.fetch }
      end
    end

    def self.random_interval_between(min,max)
      min + (rand((max - min) * 1_000.0) / 1_000.0)
    end
    
  #end
end
