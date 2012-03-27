require "spec_helper"

describe YamlString do
  subject { YamlString }

  describe "convert_hash_to_dict_property" do
    it "converts a simple hash" do
      result = subject.convert_hash_to_dict_property({ a: :b })
      result.first.should eql('"a" = "b" ;')
    end

    it "converts a nested hash" do
      result = subject.convert_hash_to_dict_property({ a: { b: :c } })
      result.first.should eql('"a.b" = "c" ;')
    end
  end

  describe "to_property_dict_string" do
    it "should handle an empty array" do
      subject.to_property_dict_string([]).should eql("{
}")
    end

    it "should properly format a dict_property" do
      dict_property_string = '"a.b" = "c"; '
      subject.to_property_dict_string([dict_property_string]).should eql("{
#{dict_property_string}
}")
    end
  end

  describe "yaml_to_string", fakefs: true do
    it "should create a properly formatted, new strings file" do
      yaml_file   = "sample.yml"
      File.open(yaml_file, "w") do |f|
        f.puts("a: ")
        f.puts("  b: 'c'")
      end
      string_file = 'sample.strings'

      subject.yaml_to_string(yaml_file, string_file)

      File.exists?(string_file).should be_true
      File.readlines(string_file).should eql([
        "{",
        "\"a.b\" = \"c\" ;",
        "}",
      ])
    end
  end
end
