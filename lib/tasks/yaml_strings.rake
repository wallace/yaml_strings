require "yaml_strings"
namespace :yaml_strings do
  desc "Converts a yaml file to a strings format and outputs to STDOUT"
  task :yaml_to_strings do
    fail "YAML_FILE must be set"           unless file = ENV['YAML_FILE']
    fail "YAML_FILE must be set to a file" unless File.exist?(file)

    yaml_hash = YAML.load(File.open(ENV['YAML_FILE']))

    fail "YAML_FILE is empty" unless yaml_hash

    puts YamlToStringsEncoder.new(yaml_hash).to_s
  end

  desc "Converts a strings file to YAML format and outputs YAML_FILE"
  task :strings_to_yaml do
    fail "STRINGS_FILE must be set"           unless file = ENV['STRINGS_FILE']
    fail "STRINGS_FILE must be set to a file" unless File.exist?(file)

    fail "YAML_FILE must be set"           unless file = ENV['YAML_FILE']

    strings_array = IO.readlines(ENV['STRINGS_FILE'])

    fail "#{ENV['STRINGS_FILE']} is empty" if strings_array.empty?

    File.open(ENV['YAML_FILE'], 'w') do |f|
      f.write(StringsToHashEncoder.new(strings_array).to_hash.to_yaml)
    end
  end
end
