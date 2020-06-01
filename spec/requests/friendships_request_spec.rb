# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Friendships', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship) }

  describe 'POST /create' do
    it 'creates new friendship' do
      expect do
        sign_in user
        post friendships_path(friend_id: friend)
      end.to change(Friendship, :count).by(1)
    end

    it 'redirects to a friends page' do
      sign_in user
      post friendships_path(friend_id: friend)
      expect(response).to redirect_to(user_path(friend))
    end
  end

  describe 'DELETE /destroy' do
    before { user.follow(friend) }

    let!(:friendship) { user.active_friendships.find_by(friend_id: friend) }

    it 'destroys friendship' do
      expect do
        sign_in user
        delete friendship_path(id: friendship)
      end.to change(Friendship, :count).by(-1)
    end

    it 'redirects to a friends page' do
      sign_in user
      delete friendship_path(id: friendship)
      expect(response).to redirect_to(user_path(friend))
    end
  end
end
# rubocop:enable Metrics/BlockLength
