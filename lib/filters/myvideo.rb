module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class MyvideoParser < BaseParser
          def initialize
            @url_patterns = [ /http:\/\/(www.)?myvideo\.de\/watch\/([A-Za-z0-9._%-]*)\/\S*/,
                              /http:\/\/(www.)?myvideo\.de\/movie\/([A-Za-z0-9._%-]*)(\&\S+)?/
                            ]
            @url_template = "http://www.myvideo.de/movie/<%= video_id %>"
            @validation_url = "http://www.myvideo.de/watch/<%= video_id %>"
          end
        end
      end
    end
  end
end