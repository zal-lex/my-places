# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get users_url
      expect(response).to be_successful
    end

    it 'renders landing page' do
      get users_url
      expect(response).to render_template(:index)
    end

    it 'takes you to the search results page' do
      get users_url params: { search: 'Andy' }
      expect(response).to render_template('users/show_search')
    end

    it 'takes you to the root page' do
      get users_url params: { search: '' }
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /show' do
    let!(:user) { FactoryBot.create(:user) }

    it 'renders a successful response' do
      get user_url(user)
      expect(response).to be_successful
    end

    it 'renders a user main page' do
      get user_url(user)
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { FactoryBot.create(:user) }

    it 'deletes user' do
      expect do
        delete user_path(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to a landing page' do
      delete user_path(user)
      expect(response).to redirect_to(root_path)
    end

    it 'shows message about user deletion' do
      delete user_path(user)
      follow_redirect!
      expect(response.body).to include 'User was deleted forever'
    end
  end
end
# rubocop:enable Metrics/BlockLength
