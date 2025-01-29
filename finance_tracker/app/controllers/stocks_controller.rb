class StocksController < ApplicationController
  
  def search
      puts "Received stock param: #{params[:stock]}" 
      @stock = Stock.new_lookup(params[:stock])
      render 'users/my_portfolio' 
  end
end