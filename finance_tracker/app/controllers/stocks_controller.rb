class StocksController < ApplicationController
  
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock.nil?
        flash.now[:alert] = "Invalid stock symbol"
        render 'users/my_portfolio' and return
      else
        render 'users/my_portfolio'
      end
    else 
      flash.now[:alert] = "Please enter a stock symbol"
      render 'users/my_portfolio'
    end
  end
end

