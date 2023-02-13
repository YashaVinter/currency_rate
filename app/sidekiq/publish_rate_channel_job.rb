class PublishRateChannelJob
  include Sidekiq::Job

  def perform(*args)
    rate = JSON.parse(args.first)["rate"]
    ActionCable.server.broadcast 'RateChannel', { rate: rate }.to_json
  end
end
