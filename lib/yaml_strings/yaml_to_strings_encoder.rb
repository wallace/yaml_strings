class YamlToStringsEncoder
  attr_accessor :yaml_hash
  def initialize(yaml_hash = {})
    @yaml_hash = yaml_hash
  end

  def to_s
    array = YamlToStringsEncoder.convert_hash_to_dict_property(yaml_hash)
    YamlToStringsEncoder.to_property_dict_string(array)
  end

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
      (["{"] + array_of_dict_propertes + ["}", nil]).join("\n")
    end
  end
end
