# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Users::FavPlacesController < ApplicationController
  respond_to :json

  def index
    @places = Place.where(id: current_user.fav_places.pluck(:likeable_id))
  end

  def show; end

  def create
    @place = Place.find(params[:place_id])
    @fav_place = current_user.fav_places.create(likeable: @place)
  end

  def destroy
    FavPlace.find(params[:id]).destroy
  end

  private

  def fav_place_params
    params.require(:fav_place).permit(:user_id, :likeable)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
