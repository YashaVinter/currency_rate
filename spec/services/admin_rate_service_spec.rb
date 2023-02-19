require "rails_helper"

RSpec.describe AdminRateService do
  describe "#set_active" do
    context "return rate" do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it "write admin_rate_active to Rails.cache" do
        allow(GetAndPublishLastRateJob).to receive(:perform_in)
        admin_rate = AdminRate.create!(end_timestamp: (Time.now + 1.minute).to_i, dollar_rate_attributes: { rate: 50, timestamp: Time.now.to_i })
        service = described_class.new(admin_rate)
        service.set_active
        admin_rate_active_after = Rails.cache.read("admin_rate_active")
        expect(admin_rate_active_after).to be_truthy
      end

      it "write admin_rate to Rails.cache" do
        allow(GetAndPublishLastRateJob).to receive(:perform_in)
        admin_rate = AdminRate.create!(end_timestamp: (Time.now + 1.minute).to_i, dollar_rate_attributes: { rate: 50, timestamp: Time.now.to_i })
        service = described_class.new(admin_rate)
        service.set_active
        admin_rate_after = Rails.cache.read("admin_rate")
        expect(admin_rate_after).to be_truthy
      end

      it "raise error if end_timestamp lower then now timestamp" do
        allow(GetAndPublishLastRateJob).to receive(:perform_in)
        admin_rate = AdminRate.create!(end_timestamp: (Time.now - 1.minute).to_i, dollar_rate_attributes: { rate: 50, timestamp: Time.now.to_i })
        service = described_class.new(admin_rate)
        expect{ service.set_active }.to raise_error(AdminRateService::NegativeTimestampError)
      end
    end
  end
end
