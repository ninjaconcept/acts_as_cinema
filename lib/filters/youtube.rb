module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class YoutubeParser < BaseParser          
          def initialize
            @url_patterns = [ /http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/,
                              /http:\/\/(www.)?youtube\.com\/v\/([A-Za-z0-9._%-]*)(\&\S+)?/,
                              /http:\/\/(www.)?youtube\.com\/user\/.+?#p\/.+\/.+\/.+\/([A-Za-z0-9._%-]*)(\&\S+)?/
                            ]
            @url_template = "http://www.youtube.com/v/<%= video_id %>&fs=1"
            @validation_url = "http://www.youtube.com/v/<%= video_id %>&fs=1"
          end
        end
      end
    end
  end
end