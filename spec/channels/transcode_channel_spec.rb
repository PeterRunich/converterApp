require 'rails_helper'

RSpec.describe TranscodeChannel, type: :channel do
  it "subscribes" do
    subscribe(transcode_id: SecureRandom.uuid)

    expect(subscription).to be_confirmed
  end
end
