RSpec.describe Sidekiq::StagedPush do
  it "has a version number" do
    expect(Sidekiq::StagedPush::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
