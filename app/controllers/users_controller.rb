# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    if params[:search]
      @users = User.search(params[:search])
      render 'show_search'
    else
      @users = User.all
    end
  end

  def show; end

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
