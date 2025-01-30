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

  # def create
  #   # Assuming you're adding the stock to the user's portfolio here
  #   @stock = Stock.find_by(ticker: params[:ticker])
  #   if @stock && current_user
  #     # Add the stock to the user's portfolio (assuming you have a `has_many :stocks` relationship)
  #     current_user.stocks << @stock
  #     flash[:notice] = "Stock added to your portfolio"
  #   else
  #     flash[:alert] = "Could not add stock to portfolio"
  #   end
  #   redirect_to my_portfolio_path
  # end
end
