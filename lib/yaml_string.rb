require "yaml_string/version"

module YamlString
  class << self
    # Returns an array of dict properties as strings
    #
    # hsh - a hash to convert into the string representation
    # prev_keys - a string representing the previous keys of enclosing hashes
    #
    # Ex: { a: :b } # => "a" = "b";
    # Ex: { a: { b: :c } } # => "a.b" = "c";
    def convert_hash_to_dict_property(hsh, prev_keys = nil)
      result = []
      hsh.each_pair {|k,v|
        if v.is_a?(Hash)
          new_prev_keys  = "#{[prev_keys, k].compact.join('.')}"
          result        += convert_hash_to_dict_property(v, new_prev_keys)
        else
          result        += ["\"#{[prev_keys, k].compact.join('.')}\" = \"#{v}\" ;"]
        end
      }
      result
    end

    # Returns a string representing an old ASCII style property list
    def to_property_dict_string(array_of_dict_propertes)
      (["{"] + array_of_dict_propertes + ["}"]).join("\n")
    end

    def yaml_to_string(yaml_file, string_file)
      yaml_hash = YAML.load(File.open(yaml_file))
      array     = convert_hash_to_dict_property(yaml_hash)

      File.open(string_file, "w") do |f|
        f.puts to_property_dict_string(array)
      end
    end
  end
end
