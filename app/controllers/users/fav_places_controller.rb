# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Users::FavPlacesController < ApplicationController
  respond_to :json

  def index
    @places = Place.where(id: current_user.fav_places.pluck(:likeable_id))
  end

  def show; end

  def create
    @fav_place =  @place.fav_places.create(user_id: current_user.id, likeable: @place)
    respond_to do |format|
      format.html { redirect_to @fav_place }
      format.json { render :show, status: :set_like, location: @fav_place }
    end
  end

  def destroy
    @fav_place = @place.fav_places.find(params[:id])
    @fav_place.destroy
    respond_to do |format|
      format.html { redirect_to fav_places_url(@fav_place) }
      format.json { head :removed_like }
    end
  end

  private

  def set_fav_place
    @fav_places = FavPlace.find_by(user_id: current_user.id)
  end

  def fav_place_params
    params.require(:fav_place).permit(:user_id, :likeable_id, :likeable_type)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
