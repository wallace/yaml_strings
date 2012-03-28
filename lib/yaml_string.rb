require "yaml_string/version"
require "yaml_string/yaml_to_strings_encoder"
require "yaml_string/strings_to_yaml_encoder"

module YamlString
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
