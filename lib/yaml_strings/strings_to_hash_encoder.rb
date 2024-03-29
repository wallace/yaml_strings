class InvalidKeyError < StandardError; end
class InvalidValueError < StandardError; end
class InvalidTerminatorError < StandardError; end

class StringsToHashEncoder
  attr_accessor :strings_array
  def initialize(strings_array = [])
    @strings_array = strings_array
  end

  def to_hash
    StringsToHashEncoder.parse_strings_array(@strings_array)
  end

  class << self
    # Returns a hash when given
    def parse_strings_array(array)
      raise ArgumentError.new("Invalid strings format: missing '{\\n'") unless /{/.match(array.shift)
      raise ArgumentError.new("Invalid strings format: missing '}'")    unless /}/.match(array.pop)

      array.inject({}) do |hash,line|
        key_string, value = parse_strings_key_value(line)

        key_string = remove_quotes(key_string)
        value      = remove_quotes(value)
        keys = key_string.split('.') + [value]

        recursive_merge(hash, nested_hash(keys))
      end
    end

    # Adapted from http://stackoverflow.com/a/8415328
    def recursive_merge(a, b)
      a.merge(b) {|key, a_item, b_item| recursive_merge(a_item, b_item) } 
    end

    # %{ a b c d } =>
    #
    # { a => { b => { c => d } } }
    #
    def nested_hash(keys)
      keys.reverse.inject { |hsh, elem| { elem => hsh } }
    end

    # Returns true if the value is a valid string NSString
    #
    # See http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/PropertyLists/OldStylePlists/OldStylePLists.html#//apple_ref/doc/uid/20001012-BBCBDBJE
    # for more info
    def valid_string?(value)
      (value       =~ /\s*"[^"]*"\s*/ ||
       value.strip =~ /\A\S+\Z/) &&
       value.strip != ';'                # handles case where no text in the value
    end

    # Returns true if the last character of the string, ignoring spaces, is a
    # semi-colon.
    def valid_terminator?(value)
      return false if value.nil? || value == ""

      value.gsub(' ', '')[-1] == ";"
    end

    def remove_quotes(key_string)
      key_string = key_string.strip[1..-1] if key_string.strip[0]  == '"'
      key_string = key_string.strip[0..-2] if key_string.strip[-1] == '"'
      key_string.strip!
      key_string
    end

    # Validates the format
    def parse_strings_key_value(line)
      key_string, value = line.split('=')

      key_string.strip!
      value.strip!

      raise InvalidValueError.new("Invalid strings format: Missing value for line after '=': '#{line}'")     unless valid_string?(value)
      raise InvalidKeyError.new("Invalid strings format: Missing key for line before '=': '#{line}'")        unless valid_string?(key_string)
      raise InvalidTerminatorError.new("Invalid strings format: Missing terminator ';' for line: '#{line}'") unless valid_terminator?(value)

      value = value[0..-2] # Removes the ; from the value

      return key_string, value
    end
  end
end
