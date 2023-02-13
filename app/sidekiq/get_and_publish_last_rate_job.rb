class GetAndPublishLastRateJob
  include Sidekiq::Job

  def perform(*args)
    rate = ExternalCurrencyService.new.coingate_dollar_rate
    PublishRateChannelJob.perform_async({ rate: }.to_json)
  end
end
