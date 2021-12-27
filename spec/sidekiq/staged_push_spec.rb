# frozen_string_literal: true

require "sidekiq/worker"
require "sidekiq/job"

RSpec.describe Sidekiq::StagedPush do
  describe ".enable!" do
    it "modifies the default behaviour of Sidekiq so it calls Sidekiq::StagedPush::Client" do
      worker_class = Class.new do
        include Sidekiq::Worker
      end

      allow(Sidekiq::StagedPush::Client).to receive_message_chain(:new, :push)

      described_class.enable!
      worker_class.perform_async

      expect(Sidekiq::StagedPush::Client).to have_received(:new)
    end

    it "works the same with Sidekiq::Job" do
      worker_class = Class.new do
        include Sidekiq::Job
      end

      allow(Sidekiq::StagedPush::Client).to receive_message_chain(:new, :push)

      described_class.enable!
      worker_class.perform_async

      expect(Sidekiq::StagedPush::Client).to have_received(:new)
    end
  end
end
