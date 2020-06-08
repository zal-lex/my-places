# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'FavPlaces', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:place) { FactoryBot.create(:place) }

  describe 'POST /create' do
    it 'creates new fav_place' do
      expect do
        sign_in user
        post user_fav_places_path(user_id: user.id, place_id: place.id)
      end.to change(FavPlace, :count).by(1)
    end

    it 'renders a successful response' do
      sign_in user
      post user_fav_places_path(user_id: user.id, place_id: place.id)
      expect(response).to be_successful
    end
  end

  describe 'DELETE /destroy' do
    let!(:fav_place) { FactoryBot.create(:fav_place) }

    it 'destroys friendship' do
      expect do
        sign_in user
        delete user_fav_place_path(id: fav_place, user_id: user.id)
      end.to change(FavPlace, :count).by(-1)
    end

    it 'renders a successful response' do
      sign_in user
      delete user_fav_place_path(id: fav_place, user_id: user.id)
      expect(response).to be_successful
    end
  end
end
# rubocop:enable Metrics/BlockLength
