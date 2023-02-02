class DollarRate < ApplicationRecord
  def self.check_admin_reset
    Rails.cache.write("set_admin_rate", product_ids, expires_in: 2.days)

    set_admin_rate = Rails.cache.read("set_admin_rate")
    if set_admin_rate.present?
      
    end
  end

  def self.check_admin_reset_1
    if @@set_admin_rate[:set] && @@set_admin_rate[:timestamp_end] < Time.now.to_i
      ActionCable.server.broadcast 'RateChannel', {mes: "Ура возврат к прежнему времени"}.to_json
      @@set_admin_rate = { set: false }
    end
  end
  
  def self.set_rate
    $set_admin_rate
  end

    # a = {
    #   set: true,
    #   timestamp_end: 1675102580
    # }
  def self.set_rate=(value)
    $set_admin_rate = value
  end
  
  def self.json_read
    file_data = File.read("../currency_rate_3/db/tmp.json")
    p "file_data", JSON.parse(file_data)
  end

  def self.last_rate
    p "DollarRate.last", self.last
  end
  
  
end
