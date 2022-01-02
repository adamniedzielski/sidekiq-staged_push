# frozen_string_literal: true

require "sidekiq/staged_push/staged_job"
require "sidekiq/client"

module Sidekiq
  module StagedPush
    class Enqueuer
      class ProcessBatch
        BATCH_SIZE = 500

        def call
          StagedJob.transaction do
            jobs = StagedJob.order(:id).limit(BATCH_SIZE).to_a

            if jobs.present?
              client = Sidekiq::Client.new
              jobs.each do |job|
                client.push(job.payload)
              end
              StagedJob.where(id: jobs.map(&:id)).delete_all
            end

            jobs.size
          end
        end
      end
    end
  end
end
