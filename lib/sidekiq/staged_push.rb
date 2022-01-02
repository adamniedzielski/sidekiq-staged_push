# frozen_string_literal: true

require "sidekiq"
require "sidekiq/worker"
require "sidekiq/staged_push/enqueuer"
require "sidekiq/staged_push/worker"
require "sidekiq/staged_push/version"

module Sidekiq
  module StagedPush
    def self.enable!
      Sidekiq::Worker::ClassMethods.prepend Sidekiq::StagedPush::Worker::ClassMethods

      enqueuer = Enqueuer.new
      Sidekiq.configure_server do |config|
        config.on(:startup) do
          enqueuer.start
        end
        config.on(:quiet) do
          enqueuer.stop
        end
      end
    end
  end
end
