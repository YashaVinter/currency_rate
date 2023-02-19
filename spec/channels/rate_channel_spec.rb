require "rails_helper"

RSpec.describe RateChannel, :type => :channel do
  it "successfully connect" do
    subscribe
    expect(subscription).to be_confirmed
  end
end