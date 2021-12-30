# frozen_string_literal: true

RSpec.describe Sidekiq::StagedPush::Worker do
  it "overrides .client_push to forward to Sidekiq::StagedPush::Client" do
    job_class = Class.new do
      extend Sidekiq::StagedPush::Worker::ClassMethods
    end
    item = { class: job_class, args: [11] }
    client = instance_double(Sidekiq::StagedPush::Client, push: nil)
    allow(Sidekiq::StagedPush::Client).to receive(:new).and_return(client)

    job_class.client_push(item)

    expect(client).to have_received(:push).with("class" => job_class, "args" => [11])
  end
end
