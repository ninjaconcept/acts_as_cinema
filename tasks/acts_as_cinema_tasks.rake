# Regenerate all the converted url for exsiting records
# Usage:
#   rake acts_as_cinema:rebuild["model_name"]
# if no +model_name+ is given, the default name 'video' will be used

namespace :acts_as_cinema do
  desc "rebuild short source_param"
  task :rebuild, :model_name, :needs => :environment do |cmd, args|
    args.with_defaults(:model_name => 'video')
    puts "Start:"
    begin
      args[:model_name].classify.constantize.all.each do|video|
        video.generate_source_param
        puts "Orignal input:"
        puts video.original_input
        puts "Converted url:"
        puts video.source_param
        puts "-------------------------------------------------------------------"
      end
      puts "Done!"
    rescue => e
      puts "Error occurs during the operation: #{e.message}"
    end
  end
end