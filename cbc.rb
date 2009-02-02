require 'rubygems'

postal_codes = File.open("postal_codes.txt").read.split("\n")
# randomize to make the pattern slightly harder to see in logs
postal_codes = postal_codes.sort_by {|e| rand(10_000)}

postal_codes.each do |pc|
  begin
    scraper  = CbcScraper.new(pc)
    next if File.exists?(scraper.filename)
    
    File.open(scraper.filename, "w") do |f|
      f.puts scraper.fetch
    end
    sleep 1
  rescue
    puts "could not fetch #{pc}, sleeping for a bit"
    sleep 20
    retry
  end
end

