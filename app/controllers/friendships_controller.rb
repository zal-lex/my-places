# frozen_string_literal: true

class FriendshipsController < ApplicationController
  def create
    @user = User.find(params[:friend_id])
    current_user.follow(@user)
    redirect_to @user
  end

  def destroy
    @user = Friendship.find(params[:id]).friend
    current_user.unfollow(@user)
    redirect_to @user
  end
end
