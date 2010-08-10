require 'spec_helper'

module RSpec
  module Mocks
    describe "AnyInstance" do
      before(:each) do
        @klass = Class.new
      end

      describe "#new decoration" do
        it "should not affect all Classes" do
          @klass.any_instance
          @klass.should respond_to(:__new_without_any_instance_stubbed__)
          String.should_not respond_to(:__new_without_any_instance_stubbed__)
        end

        it "should alias Class#new on the first invocation of any_instance" do
          @klass.any_instance
          @klass.__new_without_any_instance_stubbed__.should be_a(@klass)
        end
      end

      describe "Recorder" do
        it "should record stub related messages sent to it with call chaining" do
          recorder = AnyInstance::Recorder.new
          recorder.stub!(:foo).with(1).and_return("1")
          recorder.messages.should == [[[:stub!, :foo], nil], [[:with, 1], nil], [[:and_return, "1"], nil]]
        end
      end

      it "should know how to build an AnyInstance::Recorder" do
        @klass.any_instance.should be_a(AnyInstance::Recorder)
      end

      it "should use a recorder to store messages for all instances" do
        @klass.any_instance.stub!(:foo).with(1).and_return("1")
        obj = Object.new
        @klass.__send__(:__recorder).playback!(obj)
        obj.foo(1).should == "1"
      end

      it "should stub a method call on all instances of a particular class" do
        @klass.any_instance.stub!(:foo).and_return(1)
        @klass.new.foo.should == 1
      end
    end
  end
end
