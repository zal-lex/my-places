# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe 'Places', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:place) { FactoryBot.create(:place) }
  let(:valid_attributes) do
    {
      title: 'New place',
      description: 'Description of new place',
      latitude: 55,
      longitude: 44
    }
  end
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /index' do
    it 'renders a successful response' do
      get user_places_path(user_id: place.author_id), headers: headers
      expect(response).to be_successful
    end

    it 'response contains right JSON schema' do
      get user_places_path(user_id: place.author_id), headers: headers
      expect(response).to match_json_schema('places/index')
    end
  end

  describe 'POST /create' do
    context 'with valid attributes' do
      it 'creates a new Place' do
        expect do
          sign_in user
          post user_places_path(user_id: user.id),
               params: { place: valid_attributes }, headers: headers
        end.to change(Place, :count).by(1)
      end

      it 'renders a successful response' do
        sign_in user
        post user_places_path(user_id: user.id),
             params: { place: valid_attributes }, headers: headers
        expect(response).to be_successful
      end

      it 'response contains right JSON schema' do
        sign_in user
        post user_places_path(user_id: user.id),
             params: { place: valid_attributes }, headers: headers
        expect(response).to match_json_schema('place')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the place' do
      expect do
        delete user_place_path(user_id: user.id, id: place.id)
      end.to change(Place, :count).by(-1)
    end

    it 'renders a successful response' do
      delete user_place_path(user_id: user.id, id: place.id)
      expect(response).to be_successful
    end
  end
end
# rubocop:enable Metrics/BlockLength
