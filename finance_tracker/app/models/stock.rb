class Stock < ApplicationRecord
  def refresh_price!
    data = AlphaVantageService.fetch_stock_data(ticker)
    update(last_price: data[:last_price])
  end

  require 'net/http'
  require 'json'

  def self.new_lookup(ticker_symbol)
    api_key = Rails.application.credentials.alpha_vantage[:api_key]
    url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{api_key}"
    
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    if result["Global Quote"].nil? || result["Global Quote"].empty?
      return nil
    else
      return result["Global Quote"]["05. price"].to_f
    end
  rescue => e
    Rails.logger.error("Error fetching stock data: #{e.message}")
    nil
  end

end
