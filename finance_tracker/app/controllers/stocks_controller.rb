class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock.nil?
        flash.now[:alert] = "Invalid stock symbol"
        respond_to do |format|
          format.html { render 'users/my_portfolio' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("stock-info", partial: "shared/empty_stock") }
        end
      else
        respond_to do |format|
          format.html { render 'users/my_portfolio' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("stock-info", partial: "users/result") }
        end
      end
    else
      flash.now[:alert] = "Please enter a stock symbol"
      respond_to do |format|
        format.html { render 'users/my_portfolio' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("stock-info", partial: "shared/empty_stock") }
      end
    end
  end
end
