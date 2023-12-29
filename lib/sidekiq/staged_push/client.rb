# frozen_string_literal: true

require "sidekiq/client"
require "sidekiq/staged_push/staged_job"

module Sidekiq
  module StagedPush
    class Client
      def initialize(pool: nil, config: nil)
        @redis_client = Sidekiq::Client.new(pool: pool, config: config)
      end

      def push(item)
        StagedJob.create!(payload: item)
      end

      # Same as for Sidekiq::TransactionAwareClient we don't provide
      # transactionality for push_bulk.
      def push_bulk(items)
        @redis_client.push_bulk(items)
      end
    end
  end
end
