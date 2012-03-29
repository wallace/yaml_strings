require "yaml_strings"
namespace :yaml_strings do
  desc "Converts a yaml file to a strings format"
  task :yaml_to_strings do
    fail "YAML_FILE must be set"           unless file = ENV['YAML_FILE']
    fail "YAML_FILE must be set to a file" unless File.exist?(file)

    yaml_hash = YAML.load(File.open(ENV['YAML_FILE']))

    fail "YAML_FILE is empty" unless yaml_hash

    puts YamlToStringsEncoder.new(yaml_hash).to_s
  end
end
