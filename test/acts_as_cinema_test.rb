require 'test_helper'

class ActsAsCinemaTest < Test::Unit::TestCase
    
  class Video < ActiveRecord::Base
  end
  
  def test_db_loaded
    assert_equal [], Video.all
  end
  
end
