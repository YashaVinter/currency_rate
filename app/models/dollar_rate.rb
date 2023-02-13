class DollarRate < ApplicationRecord

  def self.get_and_save_last_rate
    rate = ExternalCurrencyService.new.coingate_dollar_rate
    create!(rate:, timestamp: Time.current.to_i)
    PublishRateChannelJob.perform_async({ rate: }.to_json)
  end
  
end
