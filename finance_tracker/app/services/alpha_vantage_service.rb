require 'net/http'
require 'json'

class AlphaVantageService
  BASE_URL = 'https://www.alphavantage.co/query'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_stock_data(symbol)
    params = {
      function: 'GLOBAL_QUOTE',
      symbol: symbol,
      apikey: @api_key
    }

    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data['Global Quote']
      {
        symbol: symbol,
        price: data['Global Quote']['05. price'],
        change: data['Global Quote']['09. change'],
        change_percent: data['Global Quote']['10. change percent']
      }
    else
      nil
    end
  end
end
