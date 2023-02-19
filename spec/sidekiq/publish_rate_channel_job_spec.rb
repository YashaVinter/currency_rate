require "rails_helper"
require "sidekiq/testing"

RSpec.describe PublishRateChannelJob, :type => :job do
  describe "#perform_async" do
    after do
      described_class.clear
    end
    it "increase jobs by 1" do
      rate = {rate: 1230}.to_json
      expect do
        described_class.perform_async(rate )
      end.to change(described_class.jobs, :size).by(1)
    end

    it "broadcasted_to RateChannel" do
      rate = {rate: 1230}.to_json
      described_class.perform_async(rate)
      expect{ described_class.drain }.to have_broadcasted_to("RateChannel")
    end
    
  end
end