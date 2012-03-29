require "spec_helper"

describe YamlToStringsEncoder do
  describe "class methods" do
    subject { YamlToStringsEncoder }

    describe ".convert_hash_to_dict_property" do
      it "converts a simple hash" do
        result = subject.convert_hash_to_dict_property({ a: :b })
        result.first.should eql('"a" = "b" ;')
      end

      it "converts a nested hash" do
        result = subject.convert_hash_to_dict_property({ a: { b: :c } })
        result.first.should eql('"a.b" = "c" ;')
      end
    end

    describe ".to_property_dict_string" do
      it "should handle an empty array" do
        subject.to_property_dict_string([]).should eql(
<<STRINGS
{
}
STRINGS
        )
      end

      it "should properly format a dict_property" do
        dict_property_string = '"a.b" = "c"; '
        subject.to_property_dict_string([dict_property_string]).should eql(
<<STRINGS
{
#{dict_property_string}
}
STRINGS
        )
      end
    end
  end

  describe "#to_s" do
    it "should create a properly formatted 'strings' string" do
      subject.yaml_hash = { a: { b: :c } }
      subject.to_s.should eql(
<<STRINGS
{
"a.b" = "c" ;
}
STRINGS
      )
    end
  end
end
