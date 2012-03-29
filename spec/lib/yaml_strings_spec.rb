require "spec_helper"

describe YamlStrings, fakefs: true do
  it "should create a properly formatted, new strings file" do
    yaml_file   = "sample.yml"
    File.open(yaml_file, "w") do |f|
      f.puts("a: ")
      f.puts("  b: 'c'")
    end

    subject.yaml_to_strings(yaml_file).should eql(
<<STRINGS
{
"a.b" = "c" ;
}
STRINGS
)
  end

  it "should convert a strings file to a yaml representation" do
    strings_file   = "sample.strings"
    File.open(strings_file, "w") do |f|
      f.puts("{")
      f.puts("a.b = 'c';")
      f.puts("}")
    end

    subject.strings_to_yaml(strings_file).should eql(
<<YAML
a:
  b: 'c'
YAML
)
  end
end
