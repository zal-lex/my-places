# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable RSpec/LetSetup
# rubocop:disable Layout/LineLength
require 'rails_helper'
require 'pry'
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

  describe "GET '/users/auth/facebook'" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                      provider: 'facebook',
                                                                      uid: '123545',
                                                                      info: {
                                                                        email: 'test@example.com',
                                                                        password: '123123'
                                                                      },
                                                                      credentials: {
                                                                        token: '123456',
                                                                        expires_at: Time.zone.now + 1.week
                                                                      },
                                                                      extra: {
                                                                        raw_info: {
                                                                          name: 'Gaius',
                                                                          username: 'Baltar',
                                                                          gender: 'male'
                                                                        }
                                                                      }
                                                                    })

      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    context 'when user signs in via facebook for the first time' do
      it "creates a new user if there's a user profile on facebook" do
        expect do
          get '/users/auth/facebook/callback'
          User.from_omniauth(OmniAuth.config.mock_auth[:facebook])
        end.to change(User, :count).by(1)
      end

      it 'redirects to user page' do
        get '/users/auth/facebook/callback'
        user = User.from_omniauth(OmniAuth.config.mock_auth[:facebook])
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'when user signs in via facebook not for the first time' do
      let!(:user) { FactoryBot.create(:user_facebook) }

      it 'does not create additional user' do
        expect do
          get '/users/auth/facebook/callback'
          User.from_omniauth(OmniAuth.config.mock_auth[:facebook])
        end.to change(User, :count).by(0)
      end

      it 'finds the registered before user' do
        get '/users/auth/facebook/callback'
        user2 = User.from_omniauth(OmniAuth.config.mock_auth[:facebook])
        expect(user).to eq(user2)
      end
    end
  end

  describe 'empty email in Facebook auth' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                      provider: 'facebook',
                                                                      uid: '123545',
                                                                      info: {
                                                                        email: '',
                                                                        password: '123123'
                                                                      },
                                                                      credentials: {
                                                                        token: '123456',
                                                                        expires_at: Time.zone.now + 1.week
                                                                      },
                                                                      extra: {
                                                                        raw_info: {
                                                                          name: 'Gaius',
                                                                          username: 'Baltar',
                                                                          gender: 'male'
                                                                        }
                                                                      }
                                                                    })

      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    context 'when user is not logged in in his facebook account' do
      it 'redirects to the main page' do
        get '/users/auth/facebook/callback'
        User.from_omniauth(OmniAuth.config.mock_auth[:facebook])
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end

  describe 'Failure' do
    after do
      Rails.application.reload_routes!
    end

    before do
      Rails.application.routes.draw do
        devise_scope :user do
          get '/users/auth/failure' => 'users/omniauth_callbacks#failure'
        end
        root 'static_pages#index'
      end

      get '/users/auth/failure'
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/LetSetup
# rubocop:enable Layout/LineLength
