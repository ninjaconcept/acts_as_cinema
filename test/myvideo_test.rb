require 'test_helper'

class MyvideoTest < Test::Unit::TestCase
  class Video < ActiveRecord::Base
    acts_as_cinema
  end
  
  def test_simple_url
    Video.create(:title => "myvideo simple url", 
                 :original_input => "http://www.myvideo.de/watch/7334646/Justin_Bieber_featuring_Ludacris_Baby")
    v = Video.find_by_title("myvideo simple url")

    assert_equal "http://www.myvideo.de/watch/7334646/Justin_Bieber_featuring_Ludacris_Baby", v.original_input
    assert_equal "http://www.myvideo.de/movie/7334646", v.source_param
  end
  
  def test_update_original_input
    Video.create(:title => "myvideo simple url with update", 
                  :original_input => "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular")
    v = Video.find_by_title("myvideo simple url with update")
  
    assert_equal "http://www.youtube.com/watch?v=NC7fqQE995I&feature=popular", v.original_input
    assert_equal "http://www.youtube.com/v/NC7fqQE995I&fs=1", v.source_param
    
    v.update_attribute(:original_input, "http://vimeo.com/10819887")
    
    assert_equal "http://vimeo.com/moogaloop.swf?clip_id=10819887", v.source_param
  end
  
  def test_embeded_content
    embeded_content = %{
      <object style='width:470px;height:285px;' width='470' height='285'>
        <param name='movie' value='http://www.myvideo.de/movie/7334646'></param>
        <param name='AllowFullscreen' value='true'></param>
        <param name='AllowScriptAccess' value='always'></param>
        <embed src='http://www.myvideo.de/movie/7334646' width='470' height='285' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true'></embed>
      </object>
    }
    
    Video.create(:title => "myvideo embeded content", :original_input => embeded_content)
    v = Video.find_by_title("myvideo embeded content")
  
    assert_equal "http://www.myvideo.de/movie/7334646", v.source_param
  end
  
  def test_invalid_url
    v = Video.create(:title => "myvideo invalid url", 
                 :original_input => "http://www.myvideo.de/watch/1")

    assert_not_equal 0, v.errors.size
    assert_equal "no valid url", v.errors.on(:original_input)
  end
end
