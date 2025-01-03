# frozen_string_literal: true

require "sidekiq"
require "sidekiq/job"
require "sidekiq/staged_push/client"
require "sidekiq/staged_push/enqueuer"
require "sidekiq/staged_push/version"
require "with_advisory_lock"

module Sidekiq
  module StagedPush
    def self.enable!
      Sidekiq.default_job_options["client_class"] = Sidekiq::StagedPush::Client
      Sidekiq::JobUtil::TRANSIENT_ATTRIBUTES << "client_class"

      Sidekiq.configure_server do |config|
        enqueuer = Enqueuer.new(config)

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
