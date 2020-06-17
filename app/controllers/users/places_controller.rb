# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Users::PlacesController < ApplicationController
  respond_to :json

  def index
    @places = User.find(params[:user_id]).places.with_attached_photos
  end

  def create
    @place = current_user.places.build(place_params)

    @place.photos.attach(params[:photos]) if @place.save && params[:photos] != 'undefined'
  end

  def destroy
    Place.find(params[:id]).destroy
  end

  private

  def place_params
    params.require(:place).permit(:author_id, :title, :description, :latitude,
                                  :longitude, photos: [])
  end
end
# rubocop:enable Style/ClassAndModuleChildren
