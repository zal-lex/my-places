# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Users::Places::LikesController < ApplicationController
  respond_to :json

  def create
    @place = Place.find(params[:place_id])
    @fav_place = current_user.fav_places.create(likeable: @place)
  end

  def destroy
    FavPlace.find_by(user_id: current_user.id,
                     likeable_id: params[:place_id],
                     likeable_type: 'Place').destroy
  end
end
# rubocop:enable Style/ClassAndModuleChildren
