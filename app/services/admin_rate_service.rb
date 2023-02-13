class AdminRateService
  class NegativeTimestampError < StandardError; end

  def initialize(admin_rate)
    @admin_rate = admin_rate
  end

  def self.set?
    Rails.cache.read("admin_rate_active")
  end

  def self.active_rate
    Rails.cache.read("admin_rate")
  end

  def set_active
    expires_timestamp = (@admin_rate.end_timestamp.to_i - Time.current.to_i).seconds
    raise NegativeTimestampError, "Negative expires_timestamp" if expires_timestamp.negative?

    Rails.cache.write("admin_rate_active", true, expires_in: expires_timestamp)
    admin_rate_hash = { rate: @admin_rate.dollar_rate.rate, time_stamp: @admin_rate.dollar_rate.timestamp }
    Rails.cache.write("admin_rate", admin_rate_hash, expires_in: expires_timestamp)
    GetAndPublishLastRateJob.perform_in(expires_timestamp)
  end
end
