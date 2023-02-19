require "rails_helper"

RSpec.describe "Api::V1::Rates", type: :request do
  describe "GET /index" do

    context "Admin rate dont set" do
      before do
        DollarRate.create(rate: 123, timestamp: 1676569424)
        get "/api/v1/rate/index"
      end

      it "return 200 code" do
        expect(response).to have_http_status(:ok)
      end

      it "return serialized last DollarRate" do
        expect(response.body).to eq(DollarRate.last.to_json(only: %i[rate timestamp]))
      end
    end

    context "Admin rate is set" do
      it "return setted admin active_rate" do
        allow(AdminRateService).to receive(:set?).and_return(true)
        active_rate = { rate: 123, timestamp: 1676569424 }.to_json
        allow(AdminRateService).to receive(:active_rate).and_return(active_rate)
        get "/api/v1/rate/index"
        expect(response.body).to eq(active_rate)
      end
    end
  end

  describe "POST /create" do
    context "correct params" do
      let(:params) { {rate: {new_rate: 123, new_rate_date: (Time.now + 1.year).to_i}} } 
      before do
        allow_any_instance_of(AdminRateService).to receive(:set_active)
      end

      it "create AdminRate" do
        admin_rates_before = AdminRate.count
        post "/api/v1/rate/create", params: params
        admin_rates_after = AdminRate.count
        expect(admin_rates_before).not_to eq(admin_rates_after)  
      end

      it "create DollarRate" do
        dollar_rates_before = DollarRate.count
        post "/api/v1/rate/create", params: params
        dollar_rates_after = DollarRate.count
        expect(dollar_rates_before).not_to eq(dollar_rates_after)  
      end

      it "broadcasted to RateChannel admin rate" do
        expect{ post "/api/v1/rate/create", params: params }.to have_broadcasted_to("RateChannel")
      end
      
    end

    context "incorrect params" do
      it "description" do
        incorrect_params = {rate: {new_rate: 123, new_rate_date: (Time.now - 1.year).to_i}}
        post "/api/v1/rate/create", params: incorrect_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "description" do
        incorrect_params = {rate: {new_rate: 123, new_rate_date: (Time.now - 1.year).to_i}}
        post "/api/v1/rate/create", params: incorrect_params
        expect(response.body).to eq( {error: "Negative expires_timestamp"}.to_json )
      end
      
    end
    
  end

  describe "GET /admin_rates" do
    context "under condition" do
      it "return blank array if AdminRate.count == 0" do
        get "/api/v1/rate/admin_rates"
        expect(response.body).to eq( [].to_json )
      end
      
      it "return last 5 admin rates" do
        6.times do |t|
          AdminRate.create!(end_timestamp: Time.now.to_i, dollar_rate_attributes: { rate: t * 10, timestamp: Time.now.to_i })
        end
        last_rates_limit = 5
        last_rates = AdminRate.includes(:dollar_rate).order(created_at: :desc).first(last_rates_limit)
        last_rates_json = last_rates.as_json(
          include: {
            dollar_rate: {
              only: %i[id rate timestamp]
            }
          },
          only: %i[dollar_rate end_timestamp]
        )
        get "/api/v1/rate/admin_rates"
        expect(response.body).to eq( last_rates_json.to_json )
      end
      
    end
  end
  
  
end
