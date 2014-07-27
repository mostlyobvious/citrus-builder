module Citrus
  module Builder
    class Configuration
      attr_reader :event_bus

      def initialize
        @event_bus = nil
      end

    end
  end
end