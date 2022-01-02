# frozen_string_literal: true

require "sidekiq/staged_push/enqueuer/process_batch"

module Sidekiq
  module StagedPush
    class Enqueuer
      def initialize
        @done = false
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

        Sidekiq::Senate.leader?
      end
    end
  end
end
