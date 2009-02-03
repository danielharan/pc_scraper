require 'rubygems'
require 'cbc_scraper'

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
  sleep(2 + (rand(3_000) / 1_000.0))
  rescue Exception => e
    puts "could not fetch #{pc}, sleeping for a bit (exception was #{e}"
    sleep 20
    next
  end
end