require 'citrus/builder/configuration'

module Citrus
  module Builder
    class Application
      attr_reader :configuration

      def initialize
        @configuration = Configuration.new
      end

      def start
      end

    end
  end
end