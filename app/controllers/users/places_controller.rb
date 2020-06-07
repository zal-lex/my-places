# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Users::PlacesController < ApplicationController
  respond_to :json

  def index
    @places = User.find(params[:user_id]).places
  end

  def create
    @place = current_user.places.create!(place_params)
  end

  def destroy
    Place.find(params[:id]).destroy
  end

  private

  def place_params
    params.require(:place).permit(:author_id, :title, :description, :latitude,
                                  :longitude)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
