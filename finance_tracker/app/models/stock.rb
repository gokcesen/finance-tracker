class Stock < ApplicationRecord
  def refresh_price!
    data = AlphaVantageService.fetch_stock_data(ticker)
    update(last_price: data[:last_price])
  end
end
