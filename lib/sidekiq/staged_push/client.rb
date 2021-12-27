require "sidekiq/staged_push/staged_job"

module Sidekiq
  module StagedPush
    class Client
      def push(item)
        StagedJob.create!(payload: item)
      end
    end
  end
end
