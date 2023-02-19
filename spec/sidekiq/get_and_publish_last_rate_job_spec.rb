require "rails_helper"
require "sidekiq/testing"

RSpec.describe GetAndPublishLastRateJob, :type => :job do
  describe "#perform_async" do
    after do
      described_class.clear
    end
    it "increase PublishRateChannelJob jobs by 1" do
      described_class.perform_async
      expect do
        described_class.drain
      end.to change(PublishRateChannelJob.jobs, :size).by(1)
    end

    it "call ExternalCurrencyService#coingate_dollar_rate" do
      external_currency_service_called = false
      allow_any_instance_of(ExternalCurrencyService).to receive(:coingate_dollar_rate) do
        external_currency_service_called = true
      end
      described_class.perform_async
      described_class.drain
      expect(external_currency_service_called).to be_truthy
    end
  end
end