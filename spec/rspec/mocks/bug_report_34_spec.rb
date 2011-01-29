require 'spec_helper'

module RSpec
  module Mocks
    describe Mock do
      before(:each) do
        @mock = double("test double")
      end

      treats_method_missing_as_private :subject => RSpec::Mocks::Mock.new, :noop => false
      
      after(:each) do
        @mock.rspec_reset
      end

      it "raises exception if args don't match when method called" do
        @mock.should_receive(:something).with("a","b","c").once
        @mock.should_receive(:something).with("z","x","c").once
        lambda {
          @mock.something("a","b","c")
          @mock.something("z","x","g")
        }.should raise_error(RSpec::Mocks::MockExpectationError, "Double \"test double\" received :something with unexpected arguments\n  expected: (\"z\", \"x\", \"c\")\n       got: (\"z\", \"x\", \"g\")")
      end

    end

  end
end
