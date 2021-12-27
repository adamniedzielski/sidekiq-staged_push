# frozen_string_literal: true

require "sidekiq"
require "sidekiq/worker"
require "sidekiq/staged_push/worker"
require "sidekiq/staged_push/version"

module Sidekiq
  module StagedPush
    def self.enable!
      Sidekiq::Worker::ClassMethods.prepend Sidekiq::StagedPush::Worker::ClassMethods
    end
  end
end
