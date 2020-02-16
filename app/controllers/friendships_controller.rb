class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice] = "Following friend #{friend.full_name}"
    else
      flash[:alert] = "Something was wrong with the tracking request"
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friend_name = User.find(params[:id]).full_name
    friendship.destroy
    flash[:notice] = "Stopped following #{friend_name}"
    redirect_to my_friends_path
  end
end
