class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_portfolio_update
    err_messages = []
    @tracked_stocks = current_user.stocks
    @tracked_stocks.each do |stock|
      new_stock = Stock.new_lookup(stock.ticker)
      if new_stock
        if new_stock.last_price != stock.last_price
          stock.before_price = stock.last_price
          stock.last_price = new_stock.last_price
        end
        if stock.save
          err_messages << "#{stock.ticker}: Updated"
        else
          err_messages << "#{stock.ticker}: DatabaseErr"
        end
      else
        err_messages << "#{stock.ticker}: ConectionErr"
      end
    end
    flash[:notice] = err_messages.join(", ")
    redirect_to my_portfolio_path
  end

  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends
        respond_to do |format|
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldn't find user"
          format.js { render partial: 'users/friend_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search"
        format.js { render partial: 'users/friend_result' }
      end
    end
  end
end
