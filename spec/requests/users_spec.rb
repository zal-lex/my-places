# frozen_string_literal: true

require 'rails_helper'
require 'pry'

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
end
