# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    if params[:search].present?
      @users = User.search(params[:search])
      render 'show_search'
    else
      @users = users
    end
  end

  def show; end

  def users
    @fav_places = FavPlace.all
    @hash = @fav_places.group(:likeable_id).count.sort_by { |_k, v| v }.reverse
    @place_id = @hash.map { |a| a[0] }
    @top_users_id = @place_id.map do |n|
      @place = Place.find(n)
      @author_id = @place.author_id
    end
    @top6_users_id = @top_users_id.uniq[0..5]
    User.where(id: @top6_users_id)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User was deleted forever'
    redirect_to root_path
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
