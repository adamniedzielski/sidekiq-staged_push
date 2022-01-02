# frozen_string_literal: true

RSpec.describe Sidekiq::StagedPush::Enqueuer::ProcessBatch do
  it "pushes jobs to Redis and removes from the database" do
    client = instance_double(Sidekiq::Client, push: nil)
    allow(Sidekiq::Client).to receive(:new).and_return(client)

    service = described_class.new

    first_job = Sidekiq::StagedPush::StagedJob.create!(payload: { args: [1] })
    second_job = Sidekiq::StagedPush::StagedJob.create!(payload: { args: [2] })

    service.call

    expect(client).to have_received(:push).with("args" => [1])
    expect(client).to have_received(:push).with("args" => [2])
    expect(Sidekiq::StagedPush::StagedJob.where(id: [first_job.id, second_job.id])).to eq []
  end
end
