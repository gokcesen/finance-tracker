class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

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
      stock = Stock.new
      stock.ticker = ticker_symbol
      stock.name = ticker_symbol 
      stock.last_price = result["Global Quote"]["05. price"].to_f
      return stock
    end
  rescue => e
    Rails.logger.error("Error fetching stock data: #{e.message}")
    nil
  end

end


