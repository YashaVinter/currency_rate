class RateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "RateChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
