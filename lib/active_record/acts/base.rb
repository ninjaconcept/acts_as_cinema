module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class BaseParser
          attr_accessor :url_pattern, :embed_pattern, :embed_indicator, :url_template, :validation_url
          
          def prepare_pattern(input)
            input.include?(@embed_indicator)? @embed_pattern : @url_pattern
          end
          
          def parse(input)
            input.gsub(prepare_pattern(input)) do
              video_id = $2
              return ERB.new(@url_template).result(binding) if url_valid?(video_id)
            end
            return ""
          end
          
          def url_valid?(video_id)
            url = ERB.new(@validation_url).result(binding)
            res = Net::HTTP.get_response(URI.parse(url))
            # TODO: may hadle other situation more 
            case res
            when Net::HTTPOK, Net::HTTPMovedPermanently
              return true
            else
              return false
            end
          end
        end
      end
    end
  end
end