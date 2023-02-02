class Api::V1::RateController < ApplicationController
  def index
    url_1 = "https://api.coingate.com/v2/rates/merchant/USD/RUB"
    url_2 = "https://www.cbr-xml-daily.ru/latest.js"
    res =  RestClient.get(url_1).body
    rate = { rate: res.to_f, time_stamp: Time.now.to_i }
    render json: rate
  end

  def create
    p DollarRate.new(rate: rate_params[:new_rate], timestamp: rate_params[:new_rate_date])
    ActionCable.server.broadcast 'RateChannel', {rate: rate_params[:new_rate]}.to_json

    admin_rate = AdminRate.create!(end_timestamp: rate_params[:new_rate_date], dollar_rate_attributes: { rate: rate_params[:new_rate], timestamp: Time.now.to_i })
  end

  def show
  end

  def destroy
  end
  private
    def rate_params
      params.require(:rate).permit(:new_rate, :new_rate_date)
    end
end
