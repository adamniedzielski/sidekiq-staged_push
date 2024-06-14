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
          if primary_process?
            jobs_processed = ProcessBatch.new.call
            sleep 0.2 if jobs_processed.zero?
          else
            sleep 30
          end
        end
      end

      def primary_process?
        return true unless defined?(Sidekiq::Enterprise)

        leader?
      end
    end
  end
end
