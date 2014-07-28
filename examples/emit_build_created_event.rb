#!/usr/bin/env ruby

require 'citrus/event_bus'
require 'securerandom'

push_data = JSON.load(File.read(File.join(__dir__, 'payload.json')))
event     = Citrus::EventBus::Event.for_type(:build_created, {
  'build_id'  => SecureRandom.uuid,
  'push_data' => JSON.dump(push_data)
})
Citrus::EventBus::Publisher.new.(event)
