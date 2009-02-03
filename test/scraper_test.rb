require File.dirname(__FILE__) + '/test_helper'
load File.dirname(__FILE__) + '/../scraper.thor'

class ScraperTest < Test::Unit::TestCase
  context "a Thor instance trying to evade detection" do
    setup do
      @thor = Scraper.new
      @intervals = (0..1_000).collect { @thor.send(:random_interval_between, 1, 3) }
    end
    
    should "generate intervals between 1 and 3 seconds" do
      outliers = @intervals.reject {|i| (i <= 3) && (i >= 1) }
      assert outliers.length == 0, outliers.inspect
    end
    
    should "generate varying numbers" do
      assert @intervals.uniq.length > 500
    end
  end
end