require 'test_helper'

class YoutoubeTest < Test::Unit::TestCase
  
  class Video < ActiveRecord::Base
    acts_as_cinema
  end
  
  def test_simple_url
    Video.create(:title => "youtube simple url", 
                 :original_input => "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular")
    v = Video.find_by_title("youtube simple url")

    assert_equal "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular", v.original_input
    assert_equal "http://www.youtube.com/v/NC7fqQE995I&fs=1", v.source_param
  end
  
  def test_update_original_input
    Video.create(:title => "youtube simple url with update", 
                  :original_input => "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular")
    v = Video.find_by_title("youtube simple url with update")
  
    assert_equal "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular", v.original_input
    assert_equal "http://www.youtube.com/v/NC7fqQE995I&fs=1", v.source_param
    
    v.update_attribute(:original_input, "http://vimeo.com/10819887")
    
    assert_equal "http://vimeo.com/moogaloop.swf?clip_id=10819887", v.source_param
  end
  
  def test_embeded_content
    embeded_content = %{
      <object width="480" height="385">
        <param name="movie" value="http://www.youtube.com/v/NC7fqQE995I&hl=en_US&fs=1&"></param>
        <param name="allowFullScreen" value="true"></param>
        <param name="allowscriptaccess" value="always"></param>
        <embed src="http://www.youtube.com/v/NC7fqQE995I&hl=en_US&fs=1&" 
          type="application/x-shockwave-flash" allowscriptaccess="always" 
          allowfullscreen="true" width="480" height="385"></embed>
      </object>
      }
    
    Video.create(:title => "youtube embeded content", :original_input => embeded_content)
    v = Video.find_by_title("youtube embeded content")
  
    assert_equal "http://www.youtube.com/v/NC7fqQE995I&fs=1", v.source_param
  end
  
  def test_invalid_url
    v = Video.create(:title => "youtube invalid url", 
                 :original_input => "http://www.youtube.com/watch?v=12345")

    assert_not_equal 0, v.errors.size
    assert_equal "no valid url", v.errors.on(:original_input)
  end
  def test_ajax_style_url
    Video.create(:title => "youtube ajax url",
                 :original_input => "http://www.youtube.com/user/Longjeur#p/a/u/2/6LrF3ixb8_4")
    v = Video.find_by_title("youtube ajax url")

    assert_equal "http://www.youtube.com/user/Longjeur#p/a/u/2/6LrF3ixb8_4", v.original_input
    assert_equal "http://www.youtube.com/v/6LrF3ixb8_4&fs=1", v.source_param
  end
  
end
