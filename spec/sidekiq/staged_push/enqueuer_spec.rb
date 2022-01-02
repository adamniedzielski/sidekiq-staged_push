# frozen_string_literal: true

RSpec.describe Sidekiq::StagedPush::Enqueuer do
  it "can be started and stopped" do
    allow(Sidekiq::Client).to receive_message_chain(:new, :push)

    enqueuer = described_class.new
    enqueuer.start

    job = Sidekiq::StagedPush::StagedJob.create!(payload: { args: [1] })
    sleep 1

    expect(Sidekiq::StagedPush::StagedJob.find_by(id: job.id)).to eq nil

    enqueuer.stop
    sleep 1

    job = Sidekiq::StagedPush::StagedJob.create!(payload: { args: [1] })
    sleep 1

    expect(Sidekiq::StagedPush::StagedJob.find_by!(id: job.id)).to eq job
  end
end
