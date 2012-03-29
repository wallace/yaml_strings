require "spec_helper"

describe StringsToHashEncoder do
  it "should exist" do
    lambda { subject.should be_a(StringsToHashEncoder) }.should_not raise_error(Exception)
  end

  describe "#to_hash" do
    it "should work" do
      subject.strings_array = ["{\n", "en.app_name = awesome;", "}"]
      subject.to_hash.should eql({ "en" => { "app_name" => "awesome" } })
    end

    it "should work with a more complicated strings file" do
      subject.strings_array = ["{\n", "en.app_name = awesome;", "en.helpers.create = \"Create Something\";", "}"]
      subject.to_hash.should eql({ "en" => { "app_name" => "awesome", "helpers" => { "create" => "\"Create Something\"" } } })
    end
  end

  describe "class methods" do
    subject { StringsToHashEncoder }

    describe ".parse_strings_array" do
      it "should raise an error if missing '{'" do
        lambda { subject.parse_strings_array(["}"]) }.should raise_error(ArgumentError)
      end

      it "should raise an error if missing '}'" do
        lambda { subject.parse_strings_array(["{\n"]) }.should raise_error(ArgumentError)
      end

      it "should work" do
        subject.parse_strings_array(
          ["{\n", "en.app_name = awesome;", "}"]
        ).should eql({ "en" => { "app_name" => "awesome" } })
      end
    end

    describe ".valid_string?" do
      it "returns true for a quoted string" do
        subject.valid_string?("\" \"").should be_true
      end

      it "returns true for another quoted string" do
        subject.valid_string?("\"Something good here\"").should be_true
      end

      it "returns true for non-whitespace string" do
        subject.valid_string?("something_good_here").should be_true
      end

      it "returns true for non-whitespace string with a terminator" do
        subject.valid_string?("something_good_here;").should be_true
      end

      it "returns false for non-quoted space" do
        subject.valid_string?(" ").should be_false
      end

      it "returns false for non-quoted string" do
        subject.valid_string?("something good here").should be_false
      end
    end

    describe ".valid_terminator?" do
      it "returns true if last character is a ;" do
        subject.valid_terminator?(";").should be_true
      end

      it "returns true if last character is a ; ignoring spaces" do
        subject.valid_terminator?("  ;   ").should be_true
      end

      it "returns false if last character is not a ; ignoring spaces" do
        subject.valid_terminator?("  ").should be_false
      end

      it "returns false if last character is not a ;" do
        subject.valid_terminator?(";a").should be_false
      end
    end

    describe ".parse_strings_key_value" do
      it "should raise an error if there is no value for a line" do
        lambda { subject.parse_strings_key_value("\"a.b\" = ;") }.should raise_error(InvalidValueError)
      end

      it "should raise an error if there is value for a line" do
        lambda { subject.parse_strings_key_value("\"a.b\" = asdf asdf;") }.should raise_error(InvalidValueError)
      end

      it "should raise an error if there is no key for a line" do
        lambda { subject.parse_strings_key_value(" = c;") }.should raise_error(InvalidKeyError)
      end

      it "should raise an error if there is no terminator" do
        lambda { subject.parse_strings_key_value("a.b = c") }.should raise_error(InvalidTerminatorError)
      end

      it "should work fine" do
        key_string, value = subject.parse_strings_key_value("a.b = c;")
        key_string.should eql("a.b")
        value.should eql("c")
      end
    end

    describe ".remove_quotes_from_key_string" do
      it "should remove \" from key_string" do
        subject.remove_quotes_from_key_string('"a.b"').should eql("a.b")
      end

      it "should do nothing to the string" do
        subject.remove_quotes_from_key_string('a.b').should eql("a.b")
      end
    end

    describe ".nested_hash" do
      it "handles one element arrays" do
        subject.nested_hash([:a]).should eql(:a)
      end

      it "handles two element arrays" do
        subject.nested_hash([:a, :b]).should eql({a: :b})
      end

      it "handles three element arrays" do
        subject.nested_hash([:a, :b, :c]).should eql({a: { b: :c }})
      end
    end
  end
end
