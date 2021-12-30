# frozen_string_literal: true

require "sidekiq/worker"
require "sidekiq/job"

RSpec.describe Sidekiq::StagedPush do
  describe ".enable!" do
    it "modifies the default behaviour of Sidekiq so it calls Sidekiq::StagedPush::Client" do
      allow(Sidekiq::StagedPush::Client).to receive_message_chain(:new, :push)
      allow(Sidekiq::Client).to receive_message_chain(:new, :push)

      worker_class = Class.new do
        include Sidekiq::Worker
      end
      job_class = Class.new do
        include Sidekiq::Job
      end

      worker_class.perform_async
      job_class.perform_async

      expect(Sidekiq::Client).to have_received(:new).twice
      expect(Sidekiq::StagedPush::Client).not_to have_received(:new)

      described_class.enable!

      # re-define the classes so they include the new behaviour
      worker_class = Class.new do
        include Sidekiq::Worker
      end
      job_class = Class.new do
        include Sidekiq::Job
      end

      worker_class.perform_async
      job_class.perform_async

      expect(Sidekiq::StagedPush::Client).to have_received(:new).twice
    end
  end
end
