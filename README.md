# YamlStrings

Converts a YAML file, specifically the ones typically used for locale and
translation files in Rails, to an old style Apple ASCII Property List
http://bit.ly/old_style_ascii_property_list, and vice versa.

## Installation

Add this line to your application's Gemfile:

    gem 'yaml_strings'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaml_strings

## Usage

    $ rake yaml_strings:yaml_to_strings YAML_FILE=<path_to_file> > your_file_name.strings
    $ rake yaml_strings:strings_to_yaml STRINGS_FILE=./en.strings YAML_FILE=./en.yml

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
