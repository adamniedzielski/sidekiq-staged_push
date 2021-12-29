# frozen_string_literal: true

require "active_record"

module Sidekiq
  module StagedPush
    class StagedJob < ActiveRecord::Base
      self.table_name = "sidekiq_staged_push_jobs"
    end
  end
end
