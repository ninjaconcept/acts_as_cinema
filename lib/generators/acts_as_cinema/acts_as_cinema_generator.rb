require 'rails/generators'
require 'rails/generators/migration'     

class ActsAsCinemaGenerator < Rails::Generators::Base
  class_option  :name, 
                :type => :string, 
                :desc => "class name of which you will use as video",
                :require => false,
                :default => 'Video'

  include Rails::Generators::Migration
  
  def self.source_root
     @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def create_migration_file
    migration_template 'migration.rb', "db/migrate/add_acts_as_cinema.rb"
  end
end