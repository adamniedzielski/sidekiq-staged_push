# frozen_string_literal: true

require "active_record/base"

module Sidekiq
  module StagedPush
    class StagedJob < ActiveRecord::Base
    end
  end
end
