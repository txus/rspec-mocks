module RSpec
  module Mocks
    module AnyInstance
      class Recorder
        attr_reader :messages
        def initialize
          @messages = []
        end

        def stub(*args, &block)
          @messages << [args.unshift(:stub), block]
          self
        end

        def with(*args, &block)
          @messages << [args.unshift(:with), block]
          self
        end

        def and_return(*args, &block)
          @messages << [args.unshift(:and_return), block]
          self
        end

        def playback!(target)
          @messages.inject(target) do |target, message|
            target.__send__(*message.first, &message.last)
          end
        end
      end

      def any_instance
        __decorate_new! unless respond_to?(:__new_without_any_instance__)
        __recorder
      end

    private

      def __recorder
        @__recorder ||= AnyInstance::Recorder.new
      end

      def __decorate_new!
        self.class_eval do
          class << self
            alias_method :__new_without_any_instance__, :new

            def new(*args, &blk)
              instance = __new_without_any_instance__(*args, &blk)
              __recorder.playback!(instance)
              instance
            end
          end
        end
      end
    end
  end
end
