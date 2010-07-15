module ActiveRecord
  module Acts #:nodoc:
    module Cinema #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      # Constant for field name
      ORIGINAL_INPUT = "original_input"
      SOURCE_PARAM = "source_param"
      
      # Default value for tag definition
      TAG_TEMPLATE = <<-EOV
        <object width="<%= width %>" height="<%= height %>">
          <param name="movie" value="<%= video_url %>"></param>
          <param name="allowFullScreen" value="<%= allow_full_screen %>"></param>
          <param name="bgcolor" value="#000000"></param>
          <param name="allowscriptaccess" value="always"></param>
          <embed src="<%= video_url %>" type="application/x-shockwave-flash" allowscriptaccess="always" 
            allowfullscreen="<%= allow_full_screen %>" width="<%= width %>" height="<%= height %>" wmode="transparent">
          </embed>
        </object>
      EOV
      
      # Default options for video tag
      DEFAULT_OPTIONS = {:width => 640, :height => 385, :allow_full_screen => true, :tag_template => TAG_TEMPLATE}
      
      # Sites definition
      SITES = {"youtube" => "youtube.com", "vimeo" => "vimeo.com", "myvideo" => "myvideo.de"}
      
      # This +acts_as+ extension provides the capabilities for storing and displaying video based on url or embeded content.
      # The class that has this specified needs to have a +original_input+ column defined as an text
      # and a +source_param+ defined as string on the mapped database table.
      #
      # Video example:
      #
      #   #basic usage
      #   class Video < ActiveRecord::Base
      #     acts_as_cinema
      #   end
      #
      #   # with options
      #   class Video < ActiveRecord::Base
      #     acts_as_cinema :height => "300", :width =>"400", :allowfullscreen => false
      #   end
      #
      #   # in the view, call the video_tag method to 
      #   <%= @video.video_tag %>
      #

      module ClassMethods
        
        # Configuration options are:
        #
        # * +height+ - specifies the height of the video(default: 280)
        # * +width+ -  specifies the width of the video(default: 177)
        # * +allowfullscreen+ - specifies whether allow show the video fullscreen or not(default: true)
        # 
        # 
        #   Example: <tt> :height => "300", :width =>"400", :allowfullscreen => false</tt>
        def acts_as_cinema(options = {})
          ActiveRecord::Acts::Cinema::DEFAULT_OPTIONS.merge!(options)

          class_eval <<-EOV
            include ActiveRecord::Acts::Cinema::InstanceMethods

            before_save  :generate_source_param
          EOV
        end
      end

      # All the methods available to a record that has had <tt>acts_as_cinema</tt> specified. 
      module InstanceMethods

        # Generate the +source_param+ content based on the +orignal_input+
        def generate_source_param(validate_url = true)
          video_url = ""
          original_input = read_attribute(ActiveRecord::Acts::Cinema::ORIGINAL_INPUT)

          original_input.gsub(/value=\"(http:.*?)\"/) do
            original_input = $1
          end

          ActiveRecord::Acts::Cinema::SITES.each do |k, v|
            if original_input.include?(v)
              parser = "ActiveRecord::Acts::Cinema::VideoSiteParser::#{k.capitalize}Parser".constantize.new
              video_url = parser.parse(original_input, validate_url)
            end
          end

          unless video_url == ""
            write_attribute(ActiveRecord::Acts::Cinema::SOURCE_PARAM, video_url)
          else
            self.errors.add(ActiveRecord::Acts::Cinema::ORIGINAL_INPUT.to_sym, 'no valid url')
          end
        end
        
        # Generate the video tag
        # * +options+ - you can specify height/width/allowfullscreen for an individual video here
        def video_tag(options = {})
          options = ActiveRecord::Acts::Cinema::DEFAULT_OPTIONS.merge(options)
          video_url = read_attribute(ActiveRecord::Acts::Cinema::SOURCE_PARAM)

          width = options[:width]
          height = options[:height]
          allow_full_screen = options[:allow_full_screen] ? "true" : "false"
          
          # Check the tag option, if a method is assigned, 
          # call it to get the template string
          if options[:tag_template].is_a?(Symbol) 
            tag_template = self.send options[:tag_template]
          else
            tag_template = options[:tag_template]
          end
          ERB.new(tag_template).result(binding)
        end
      end
    end
  end
end