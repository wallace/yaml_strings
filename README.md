# YamlString

Converts a YAML file, specifically the ones typically used for locale and
translation files in Rails, to an old style Apple ASCII Property List,
http://bit.ly/old_style_ascii_property_list

## Installation

Add this line to your application's Gemfile:

    gem 'yaml_string'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaml_string

## Usage

    $ rake yaml_string:convert_to_yaml[<file_or_directory>]
    $ rake yaml_string:convert_to_string[<file_or_directory>]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
