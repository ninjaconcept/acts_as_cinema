class AddActsAsCinema < ActiveRecord::Migration
  def self.up
    add_column :<%= options[:name].tableize %>, :<%= ActiveRecord::Acts::Cinema::ORIGINAL_INPUT %>, :text
    add_column :<%= options[:name].tableize %>, :<%= ActiveRecord::Acts::Cinema::SOURCE_PARAM %>, :string
  end

  def self.down
    remove_column :<%= options[:name].tableize %>, :<%= ActiveRecord::Acts::Cinema::ORIGINAL_INPUT %>
    remove_column :<%= options[:name].tableize %>, :<%= ActiveRecord::Acts::Cinema::SOURCE_PARAM %>
  end
end