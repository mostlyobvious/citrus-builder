require 'citrus/core'
require 'citrus/event_bus'

module Citrus
  module Builder
    class Configuration
      attr_reader :event_subscriber, :event_publisher, :workspace_builder, :test_runner, :config_loader, :github_adapter

      def initialize
        root               = Dir.mktmpdir('citrus')
        @event_subscriber  = Citrus::EventBus::Subscriber.new
        @event_publisher   = Citrus::EventBus::Publisher.new
        @config_loader     = Citrus::Core::ConfigurationLoader.new
        @test_runner       = Citrus::Core::TestRunner.new
        @github_adapter    = Citrus::Core::GithubAdapter.new
        @workspace_builder = Citrus::Core::WorkspaceBuilder.new(
            File.join(root, 'builds'),
            Citrus::Core::CachedCodeFetcher.new(File.join(root, 'cache'))
        )
      end

    end
  end
end