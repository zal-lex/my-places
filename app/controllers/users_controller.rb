# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show; end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1#
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :name, :age, :sex, :avatar_url)
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :name, :age, :sex, :avatar_url)
  end
end
# rubocop:enable Layout/LineLength
