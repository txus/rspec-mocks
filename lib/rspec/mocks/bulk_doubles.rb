module RSpec
  module Mocks
    module BulkDoubles

      module ClassMethods
        # Declares a bunch of test doubles at once.
        #
        # +name+ will be both the name of the double and the method name used
        # to invoke it.
        #
        # Test doubles created this way are memoized on first call.
        #
        # == Examples
        #
        #   describe "a complex system" do
        #     doubles :logger, :endpoint, :input
        #
        #     it 'works in spite of its complexity' do
        #       input.stub(:read).and_return '123'
        #       subject.stub(:logger).and_return logger
        #       subject.stub(:endpoint).and_return endpoint
        #       subject.feed input
        #       . . .
        #     end
        #   end
        def doubles(*names)
          names.each do |name|
            define_method(name) do
              __memoized[name] ||= declare_double(name)
            end
          end
        end

        private

        def declare_double(name)
          RSpec::Mocks::Mock.new(name, :__declared_as => 'Double')
        end
      end

      module InstanceMethods
        def __memoized # :nodoc:
          @__memoized ||= {}
        end
      end

      def self.included(mod) # :nodoc:
        mod.extend ClassMethods
        mod.__send__ :include, InstanceMethods
      end

    end
  end
end

if defined?(RSpec::Core::ExampleGroup)
  RSpec::Core::ExampleGroup.class_eval { include RSpec::Mocks::BulkDoubles }
end
