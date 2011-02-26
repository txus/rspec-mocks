require "spec_helper"

describe "#doubles" do

  doubles :foo, :bar, :baz

  it "generates an instance method for each name" do
    expect {
      foo
      bar
      baz
    }.to_not raise_error(NameError)
  end

  it "caches the value" do
    foo.stub(:bar).and_return 123
    foo.bar.should eq(123)
  end
  
end
