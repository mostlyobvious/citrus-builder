require 'citrus/builder/configuration'
require 'tmpdir'

module Citrus
  module Builder
    class Application

      def initialize
        @configuration = Configuration.new
      end

      def start
        usecase = Citrus::Core::ExecuteBuild.new(
          @configuration.workspace_builder,
          @configuration.config_loader,
          @configuration.test_runner
        )
        @configuration.test_runner.add_subscriber(self)
        usecase.add_subscriber(self)

        loop do
          event = @configuration.event_subscriber.()
          case event.type
            when 'build_created'
              push_data = event.body['push_data']
              uuid      = event.body['build_id']
              changeset = @configuration.github_adapter.create_changeset_from_push_data(push_data)
              usecase.(Citrus::Core::Build.new(changeset, uuid))
            else
              next
          end
        end
      end

      def build_started(build)
        event = Citrus::EventBus::Event.for_type(:build_started, {
            'build_id' => build.uuid
        })
        @configuration.event_publisher.(event)
      end

      def build_failed(build, result)
        event = Citrus::EventBus::Event.for_type(:build_failed, {
            'build_id' => build.uuid,
            'result'   => result.value
        })
        @configuration.event_publisher.(event)
      end

      def build_aborted(build, error)
        event = Citrus::EventBus::Event.for_type(:build_aborted, {
            'build_id' => build.uuid,
            'error'    => error.message
        })
        @configuration.event_publisher.(event)
      end

      def build_succeeded(build, result)
        event = Citrus::EventBus::Event.for_type(:build_succeeded, {
            'build_id' => build.uuid,
            'result'   => result.value
        })
        @configuration.event_publisher.(event)
      end

      def build_output_received(build, output)
        event = Citrus::EventBus::Event.for_type(:build_output_received, {
            'build_id' => build.uuid,
            'output'   => output
        })
        @configuration.event_publisher.(event)
      end

    end
  end
end