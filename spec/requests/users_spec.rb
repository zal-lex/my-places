# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:valid_attributes) do
    {
      name: 'User',
      username: 'mega_user',
      email: 'mega_user@some.site',
      avatar_url: 'http://site.com/mega_user.png',
      sex: 1,
      age: 22,
      password: '123456',
      password_confirmation: '123456'
    }
  end

  let(:invalid_attributes) do
    {
      name: 'User',
      username: 'mega_user',
      email: 'mega_user@some.site',
      avatar_url: 'http://site.com/mega_user.png',
      sex: 5,
      age: 22,
      password: '123456',
      password_confirmation: '123456'
    }
  end

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
    let(:user) { User.create! valid_attributes }

    it 'renders a successful response' do
      get user_url(user)
      expect(response).to be_successful
    end

    it 'renders a user main page' do
      get user_url(user)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET /new' do
    it 'renders user registration form' do
      get '/users/sign_up'
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:user) { User.create! valid_attributes }

    it 'renders a successful response' do
      get edit_user_url(user)
      expect(response).to be_successful
    end

    it 'renders profile editing page' do
      get edit_user_url(user)
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'User',
          username: 'mega_user50',
          email: 'mega_user@some.site',
          avatar_url: 'http://site.com/mega_user50.png',
          sex: 1,
          age: 22,
          password: '123456',
          password_confirmation: '123456'
        }
      end

      it 'updates the requested user' do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.username).to eq('mega_user50')
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete user_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete user_url(user)
      expect(response).to redirect_to(users_url)
    end
  end
end
# rubocop:enable Metrics/BlockLength
