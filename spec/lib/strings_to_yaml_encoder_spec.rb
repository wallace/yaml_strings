require "spec_helper"

describe StringsToYamlEncoder do
  it "should exist" do
    lambda { subject.should be_a(StringsToYamlEncoder) }.should_not raise_error(Exception)
  end
end
