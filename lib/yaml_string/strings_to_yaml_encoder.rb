class InvalidKeyError < StandardError; end
class InvalidValueError < StandardError; end
class InvalidTerminatorError < StandardError; end

class StringsToYamlEncoder
  attr_accessor :strings_array
  def initialize(strings_array = [])
    @strings_array = strings_array
  end

  # Returns a hash when given
  def parse_strings_array(array)
    raise ArgumentError.new("Invalid strings format: missing '{\\n'") if array.first != "{\n"
    raise ArgumentError.new("Invalid strings format: missing '}'") if array.last != "}"

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

  #
  def parse_strings_key_value(line)
    key_string, value = line.split('=')

    raise InvalidValueError.new("Invalid strings format: Missing value for line after '=': '#{line}'")     unless valid_string?(value)
    raise InvalidKeyError.new("Invalid strings format: Missing key for line before '=': '#{line}'")        unless valid_string?(key_string)
    raise InvalidTerminatorError.new("Invalid strings format: Missing key for line before '=': '#{line}'") unless valid_terminator?(value)

    # keys              = key_string[1..-2].split('.')
  end
end
