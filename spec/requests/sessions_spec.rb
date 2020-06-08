# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable RSpec/LetSetup
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:valid_attributes) do
    {
      name: 'User',
      username: 'mega',
      email: 'mega@ya.ru',
      avatar_url: 'http://site.com/mega_user.png',
      sex: 1,
      age: 22,
      password: '123456',
      password_confirmation: '123456',
      confirmed_at: DateTime.now,
      confirmation_token: 'dfsdfdsf#{rand(999)'
    }
  end

  describe 'sign in' do
    it 'renders a successful response for sign_in page' do
      get '/users/sign_in'
      expect(response).to be_successful
    end

    context 'with valid parameters' do
      let!(:user) { User.create! valid_attributes }

      it 'logs in in successfully' do
        post '/users/sign_in', params: { user: { signin: 'mega@ya.ru', password: '123456' } }
        follow_redirect!
        expect(response.body).to include 'Signed in successfully'
      end

      it 'redirects to the user showpage' do
        post '/users/sign_in', params: {  user: { signin: 'mega@ya.ru', password: '123456' } }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid parameters' do
      let!(:user) { User.create! valid_attributes }

      it 'remains on the sign in page' do
        post '/users/sign_in', params: { user: { signin: 'mega_wrong@ya.ru', password: '123456' } }
        expect(response.body).to include 'Invalid Signin or password.'
      end
    end
  end

  describe 'sign out' do
    let!(:user) { User.create! valid_attributes }

    it 'signs out successfully' do
      post '/users/sign_in', params: { user: { signin: 'mega@ya.ru', password: '123456' } }
      delete '/users/sign_out'
      follow_redirect!
      expect(response.body).to include 'Signed out successfully.'
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/LetSetup
