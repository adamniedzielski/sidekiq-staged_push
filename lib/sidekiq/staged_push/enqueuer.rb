# frozen_string_literal: true

require "sidekiq/staged_push/staged_job"
require "sidekiq/client"

module Sidekiq
  module StagedPush
    class Enqueuer
      BATCH_SIZE = 500

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
            StagedJob.transaction do
              jobs = StagedJob.order(:id).limit(BATCH_SIZE).to_a

              if jobs.present?
                client = Sidekiq::Client.new
                jobs.each do |job|
                  client.push(job.payload)
                end
                StagedJob.where(id: jobs.map(&:id)).delete_all
              else
                sleep 0.2
              end
            end
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
