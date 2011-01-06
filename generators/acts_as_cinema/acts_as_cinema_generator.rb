class ActsAsCinemaGenerator < Rails::Generator::NamedBase
  attr_accessor :migration_name
 
  def initialize(args, options = {})
    super
    @class_name = args[0]
  end
 
  def manifest    
    file_name = generate_file_name
    @migration_name = file_name.camelize
    record do |m|
      m.migration_template "acts_as_cinema_migration.rb.erb",
                           File.join('db', 'migrate'),
                           :migration_file_name => file_name
    end
  end 
  
  private 
  
  def generate_file_name
    "add_acts_as_cinema_to_#{@class_name.tableize}"
  end
 
end
