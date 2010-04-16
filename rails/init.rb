# Include hook code here
# class ActiveRecord::Base  
#   extend ActsAsCinema  
# end

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'active_record/acts/cinema'
require 'active_record/acts/base'
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::Cinema }

Dir["#{File.dirname(__FILE__) + '/../lib/filters'}/**/*"].each do |filter|
  require "#{filter}"
end