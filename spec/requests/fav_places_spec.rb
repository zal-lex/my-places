# frozen_string_literal: true

# rubocop:disable RSpec/LetSetup
require 'rails_helper'

RSpec.describe 'FavPlaces', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:place) { FactoryBot.create(:place) }
  let!(:fav_place) { FactoryBot.create(:fav_place, user_id: user.id, likeable: place) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /index' do
    it 'renders a successful response' do
      sign_in user
      get user_fav_places_path(user_id: user.id), headers: headers
      expect(response).to be_successful
    end

    it 'response contains right JSON schema' do
      sign_in user
      get user_fav_places_path(user_id: user.id), headers: headers
      expect(response).to match_json_schema('places/index')
    end
  end
end
# rubocop:enable RSpec/LetSetup
