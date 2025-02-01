class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      
      @tracked_stocks = current_user.stocks

      respond_to do |format|
        format.turbo_stream do
          if @stock.nil?
            render turbo_stream: [
              turbo_stream.replace("results", partial: "shared/empty_stock"),
              turbo_stream.replace("tracked_stocks", partial: "stocks/empty_tracked_stocks")
            ]
          else
            render turbo_stream: [
              turbo_stream.replace("results", partial: "users/result"),
              turbo_stream.replace("tracked_stocks", partial: "stocks/list")
            ]
          end
        end
        format.html { render 'users/my_portfolio' }
      end
    else
      flash.now[:alert] = "Please enter a stock symbol"
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("results", partial: "shared/empty_stock") }
        format.html { render 'users/my_portfolio' }
      end
    end
  end
end




