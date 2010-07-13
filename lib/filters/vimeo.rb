module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class VimeoParser < BaseParser
          def initialize
            @url_patterns = [ /http:\/\/(www.)?vimeo\.com\/([0-9]*)((\?|#)\S+)?/,
                              /http:\/\/(www.)?vimeo\.com\/moogaloop.swf\?clip_id=([A-Za-z0-9._%-]*)((\?|#)\S+)?/
                            ]
            @url_template = "http://vimeo.com/moogaloop.swf?clip_id=<%= video_id %>"
            @validation_url = "http://vimeo.com/<%= video_id %>"
          end
        end
      end
    end
  end
end