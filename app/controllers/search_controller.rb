class SearchController < ApplicationController

  def search
    if params[:to_search].present?
      @to_search = params[:to_search]

      @friends = User.search(params[:to_search])
      @friends = current_user.except_current_user(@friends)
      # if @friends
      #   respond_to do |format|
      #     format.html
      #   end
      # else
      #   respond_to do |format|
      #     flash[:notice] = "No match in users"
      #     format.html
      #   end
      # end

      @stocks = Stock.search(params[:to_search])

    else
      flash[:notice] = "Enter what do you want to search"
      redirect_back fallback_location: root_path
    end
  end

end
