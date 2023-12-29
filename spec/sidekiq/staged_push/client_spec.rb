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
        .to change(Sidekiq::StagedPush::StagedJob, :count)
        .by(1)

      job = Sidekiq::StagedPush::StagedJob.last
      expect(job.payload).to eq("class" => "TestJob", "args" => [11])
    end

    it "forwards to Sidekiq::Client if pushed in bulk" do
      mock_redis_client = instance_double(Sidekiq::Client, push_bulk: nil)
      allow(Sidekiq::Client).to receive(:new).and_return(mock_redis_client)

      client = described_class.new
      first_item = { "class" => TestJob, "args" => [11] }
      second_item = { "class" => TestJob, "args" => [12] }

      expect { client.push_bulk([first_item, second_item]) }
        .not_to change(Sidekiq::StagedPush::StagedJob, :count)

      expect(mock_redis_client).to have_received(:push_bulk).with([first_item, second_item])
    end
  end
end
