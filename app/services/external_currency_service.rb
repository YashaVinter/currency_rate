class ExternalCurrencyService
  API_COINGATE_URL = "https://api.coingate.com/v2/rates/merchant/USD/RUB"
  CBR_URL = "https://www.cbr-xml-daily.ru/latest.js"

  def cbr_dollar_rate; end

  def coingate_dollar_rate
    rate = RestClient.get(API_COINGATE_URL).body
  end
end
