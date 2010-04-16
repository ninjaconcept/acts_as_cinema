module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class YoutubeParser < BaseParser          
          def initialize
            @url_pattern = /http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/
            @embed_pattern = /http:\/\/(www.)?youtube\.com\/v\/([A-Za-z0-9._%-]*)(\&\S+)?/
            @embed_indicator = "/v/"
            @url_template = "http://www.youtube.com/v/<%= video_id %>&fs=1"
            @validation_url = "http://www.youtube.com/v/<%= video_id %>&fs=1"
          end
        end
      end
    end
  end
end