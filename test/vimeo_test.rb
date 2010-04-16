require 'test_helper'

class VimeoTest < Test::Unit::TestCase
  
  class Video < ActiveRecord::Base
    acts_as_cinema
  end
  
  def test_url
    Video.create(:title => "vimeo simple url", 
                 :original_input => "http://vimeo.com/10819887")
    v = Video.find_by_title("vimeo simple url")

    assert_equal "http://vimeo.com/10819887", v.original_input
    assert_equal "http://vimeo.com/moogaloop.swf?clip_id=10819887", v.source_param
  end
  
  def test_update_original_input
    Video.create(:title => "vimeo update url", 
                 :original_input => "http://vimeo.com/10819887")
    v = Video.find_by_title("vimeo update url")
  
    assert_equal "http://vimeo.com/10819887", v.original_input
    assert_equal "http://vimeo.com/moogaloop.swf?clip_id=10819887", v.source_param
    
    v.update_attribute(:original_input, "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular")
  
    assert_equal "http://www.youtube.com/v/NC7fqQE995I&fs=1", v.source_param
  end
  
  def test_embeded_content
    embeded_content = %{
      <object width="400" height="225">
        <param name="allowfullscreen" value="true" />
        <param name="allowscriptaccess" value="always" />
        <param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=10819887&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" />
        <embed src="http://vimeo.com/moogaloop.swf?clip_id=10819887&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" 
          type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="400" height="225"></embed>
      </object>    
      }
    
    Video.create(:title => "vimeo embeded content", :original_input => embeded_content)
    v = Video.find_by_title("vimeo embeded content")
  
    assert_equal "http://vimeo.com/moogaloop.swf?clip_id=10819887", v.source_param
  end
  
  def test_invalid_url
    v = Video.create(:title => "vimeo invalid url", 
                 :original_input => "http://vimeo.com/1")

    assert_not_equal 0, v.errors.size
    assert_equal "no valid url", v.errors.on(:original_input)
  end
end
