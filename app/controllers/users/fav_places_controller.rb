# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren

class Users::FavPlacesController < ApplicationController
  respond_to :json

  def index
    @places = Place.where(id: current_user.fav_places.pluck(:likeable_id))
  end
end
# rubocop:enable Style/ClassAndModuleChildren
