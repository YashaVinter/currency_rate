class Api::V1::RateController < ApplicationController
  def index
    if AdminRateService.set?
      render json: AdminRateService.active_rate and return
    end

    rate = DollarRate.last.as_json(only: %i[rate timestamp])
    render json: rate
  end

  def create
    admin_rate = AdminRate.create!(end_timestamp: rate_params[:new_rate_date], dollar_rate_attributes: { rate: rate_params[:new_rate], timestamp: Time.now.to_i })
    AdminRateService.new(admin_rate).set_active
    ActionCable.server.broadcast 'RateChannel', { rate: rate_params[:new_rate] }.to_json
  rescue AdminRateService::NegativeTimestampError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def admin_rates
    last_rates_limit = 5
    last_rates = AdminRate.includes(:dollar_rate).order(created_at: :desc).last(last_rates_limit)
    last_rates_json = last_rates.as_json(
      include: {
        dollar_rate: {
          only: %i[id rate timestamp]
        }
      },
      only: :dollar_rate
    )
    render json: last_rates_json
  end

  private
    def rate_params
      params.require(:rate).permit(:new_rate, :new_rate_date)
    end
end
