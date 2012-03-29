require "yaml_strings/version"
require "yaml_strings/yaml_to_strings_encoder"
require "yaml_strings/strings_to_yaml_encoder"
require "yaml_strings/load_rake_task"

module YamlStrings
  class << self
    def yaml_to_strings(yaml_file)
      yaml_hash = YAML.load(File.open(yaml_file))
      YamlToStringsEncoder.new(yaml_hash).to_s
    end

    def strings_to_yaml(string_file)
      strings_array = File.readlines(string_file)
      StringsToYamlEncoder.new(strings_array).to_s
    end
  end
end
