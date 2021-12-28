# frozen_string_literal: true

RSpec.describe Sidekiq::StagedPush::Client do
  describe "push" do
    it "saves the job to the database" do
      client = described_class.new
      job_class = Class.new
      item = { "class" => job_class, "args" => [11] }

      expect { client.push(item) }
        .to change { Sidekiq::StagedPush::StagedJob.count }
        .by(1)
    end
  end
end
