require 'rubygems'
require 'active_support'
require 'open-uri'
require 'json'

class CbcScraper
  attr_accessor :postal_code, :fsa, :ldu
  def initialize(postal_code)
    @postal_code = postal_code
    @fsa, @ldu   = postal_code.split(' ')
  end

  def filename
    "spidered/#{fsa}/#{canonical_key}"
  end
  
  def canonical_key
    "#{fsa}#{ldu}"
  end
  
  def url
    "http://www.cbc.ca/news/canadavotes/myriding/postalcodes/#{postal_code[0..0].downcase}/#{fsa.downcase}/#{ldu.downcase}.html"
  end

  def fetch
    open(url).read
  end
  
  def cached?
    File.exists?(filename)
  end
  
  def extract
    exract_all.collect {|e| e["rid"]}
  end
  
  def extract_all
    st = IO.read(filename)
    st = '[' + st unless st.starts_with?('[')
    JSON.parse(st)
  end

  class << self
    def spider(data_file)
      # randomize to make the pattern slightly harder to see in logs
      data = File.read(data_file).map {|l| l.chomp}.sort_by {|e| rand(10_000)}
  
      data.each do |datum|
        begin
          if scrape(datum)
            yield
          end
        rescue Exception => e
          # rescuing exception because that gets thrown by open TODO: see if we can catch something saner
          puts "could not fetch #{datum}, sleeping for a bit (exception was #{e}"
          sleep 20
          next
        end
      end
    end
  
    def scrape(datum)
      scraper = new(datum)

      if scraper.cached?
        false
      else
        File.open(scraper.filename, "w") {|f| f.puts scraper.fetch }
        true
      end
    end

    def extract(data_file, &block)
      data = File.read(data_file).map {|l| l.chomp}
      
      data.each { |d| puts d; yield extract_file(d) }
    end
    
    def extract_file(code)
      scraper = new(code)
      
      if scraper.cached?
        [scraper.canonical_key, scraper.extract]
      else
        [scraper.canonical_key, "404 not found"]
      end
    end
  end
end
