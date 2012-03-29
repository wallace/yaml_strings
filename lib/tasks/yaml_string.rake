namespace :yaml_string do
  desc "Converts a yaml file to a strings format"
  task :yaml_to_strings do
    fail "YAML_FILE must be set"           unless file = ENV['YAML_FILE']
    fail "YAML_FILE must be set to a file" unless File.exist?(file)

    puts 'hello'
    puts ENV['YAML_FILE']
  end
end
