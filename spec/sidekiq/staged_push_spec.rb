# frozen_string_literal: true

RSpec.describe Sidekiq::StagedPush do
  it "has a version number" do
    expect(Sidekiq::StagedPush::VERSION).not_to be nil
  end
end
