# frozen_string_literal: true

require "sidekiq/component"
require "sidekiq/staged_push/enqueuer/process_batch"

module Sidekiq
  module StagedPush
    class Enqueuer
      include Sidekiq::Component

      def initialize(config)
        @done = false
        @config = config
      end

      def start
        @thread = Thread.new(&method(:process))
      end

      def stop
        @done = true
      end

      private

      def process
        until @done
          begin
            StagedJob.with_advisory_lock!("sidekiq_staged_push", { timeout_seconds: 0 }) do
              jobs_processed = ProcessBatch.new.call
              sleep 0.2 if jobs_processed.zero?
            end
          rescue WithAdvisoryLock::FailedToAcquireLock
            sleep 30
          end
        end
      end
    end
  end
end
