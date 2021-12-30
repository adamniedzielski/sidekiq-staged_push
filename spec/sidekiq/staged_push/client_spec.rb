# frozen_string_literal: true

RSpec.describe Sidekiq::StagedPush::Client do
  describe "push" do
    # rubocop:disable all
    class TestJob; end
    # rubocop:enable all

    it "saves the job to the database" do
      client = described_class.new
      item = { "class" => TestJob, "args" => [11] }

      expect { client.push(item) }
        .to change { Sidekiq::StagedPush::StagedJob.count }
        .by(1)

      job = Sidekiq::StagedPush::StagedJob.last
      expect(job.payload).to eq("class" => "TestJob", "args" => [11])
    end
  end
end
