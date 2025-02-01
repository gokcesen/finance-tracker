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
      
     
      name_url = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=#{ticker_symbol}&apikey=#{api_key}"
      name_uri = URI(name_url)
      name_response = Net::HTTP.get(name_uri)
      name_result = JSON.parse(name_response)

      if name_result["bestMatches"].present?
        company_name = name_result["bestMatches"].first["2. name"]
        stock.name = company_name.sub(/(\.com|\.net|\.org|\.co|\.io)$/i, '')
      else
        stock.name = ticker_symbol 
      end

      stock.last_price = result["Global Quote"]["05. price"].to_f
      return stock
    end
  rescue => e
    Rails.logger.error("Error fetching stock data: #{e.message}")
    nil
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end



