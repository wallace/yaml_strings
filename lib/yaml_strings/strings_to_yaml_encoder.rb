class InvalidKeyError < StandardError; end
class InvalidValueError < StandardError; end
class InvalidTerminatorError < StandardError; end

class StringsToYamlEncoder
  attr_accessor :strings_array
  def initialize(strings_array = [])
    @strings_array = strings_array
  end

  def to_s
    parse_strings_array(@strings_array)
  end

  # Returns a hash when given
  def parse_strings_array(array)
    raise ArgumentError.new("Invalid strings format: missing '{\\n'") unless /{/.match(array.shift)
    raise ArgumentError.new("Invalid strings format: missing '}'")    unless /}/.match(array.pop)

    array.inject({}) do |hash,line|
      key_string, value = parse_strings_key_value(line)

      key_string = remove_quotes_from_key_string(key_string)
      keys = key_string.split('.')

      hash.merge!(nested_hash(keys + [value]))
    end
  end

  # %{ a b c d } =>
  #
  # { a => { b => { c => d } } }
  #
  def nested_hash(keys)
    first = keys.shift
    return first if keys.empty? # base case

    hash        = Hash.new
    hash[first] = nested_hash(keys)
    hash
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

  def remove_quotes_from_key_string(key_string)
    key_string = key_string.strip[1..-1] if key_string.strip[0]  == '"'
    key_string = key_string.strip[0..-2] if key_string.strip[-1] == '"'
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
