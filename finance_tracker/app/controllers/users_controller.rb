class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
  
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends.empty?
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update('friend-results', partial: 'users/friend_result')
          end
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update('friend-results', partial: 'users/friend_result')
          end
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('friend-results', partial: 'users/friend_result')
        end
      end
    end
  end
  
end
