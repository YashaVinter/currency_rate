require "rails_helper"

RSpec.describe ExternalCurrencyService do
  describe "#coingate_dollar_rate" do
    context "return rate" do
      it "return correct rate" do
        rate = instance_double(RestClient::Response, body: 50)
        allow(RestClient).to receive(:get).and_return(rate)
        expect(described_class.new.coingate_dollar_rate).to eq(rate.body)
      end
    end
  end
end
