module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      module VideoSiteParser
        class BaseParser
          attr_accessor :url_patterns, :url_template, :validation_url

          def parse(input, validate_url=true)
            @url_patterns.each do |pattern|
              input.scan(pattern)
              if $2 && !$2.blank?
                video_id = $2
                return ERB.new(@url_template).result(binding) if validate_url && url_valid?(video_id)
              end
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