require 'spec_helper'

module RSpec
  module Mocks
    describe AnyInstance do
      let(:klass) { Class.new }

      describe "#any_instance" do
        context "with #and_return" do
          it "stubs a method on any instance of a particular class" do
            klass.any_instance.stub(:foo).and_return(1)
            klass.new.foo.should == 1
          end

          it "returns the same object for calls on different instances" do
            return_value = Object.new
            klass.any_instance.stub(:foo).and_return(return_value)
            klass.new.foo.should be(return_value)
            klass.new.foo.should be(return_value)
          end
        end

        context "with a block" do
          it "stubs a method on any instance of a particular class" do
            klass.any_instance.stub(:foo) { 1 }
            klass.new.foo.should == 1
          end

          it "returns the same computed value for calls on different instances" do
            klass.any_instance.stub(:foo) { Object.new }
            klass.new.foo.should == klass.new.foo
          end
        end
      end
    end
  end
end
