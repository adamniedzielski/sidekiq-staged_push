# frozen_string_literal: true

require "sidekiq/staged_push/client"

module Sidekiq
  module StagedPush
    module Worker
      module ClassMethods
        def client_push(item)
          stringified_item = item.transform_keys(&:to_s)

          Sidekiq::StagedPush::Client.new.push(stringified_item)
        end
      end
    end
  end
end
