module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class VimeoParser < BaseParser
          def initialize
            @url_pattern = /http:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/
            @embed_pattern = /http:\/\/(www.)?vimeo\.com\/moogaloop.swf\?clip_id=([A-Za-z0-9._%-]*)((\?|#)\S+)?/
            @embed_indicator = "moogaloop.swf?clip_id"
            @url_template = "http://vimeo.com/moogaloop.swf?clip_id=<%= video_id %>"
            @validation_url = "http://vimeo.com/<%= video_id %>"
          end
        end
      end
    end
  end
end