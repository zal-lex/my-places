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
    @placeid = FavPlace.all.group(:likeable_id).count.sort_by { |_k, v| v }.reverse.map { |a| a[0] }
    @top_users_id = @placeid.map { |n| @author_id = Place.find(n).author_id }
    User.where(id: @top_users_id.uniq[0..5])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User was deleted forever'
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
