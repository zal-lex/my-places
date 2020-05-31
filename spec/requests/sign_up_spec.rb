# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:valid_attributes) do
    {
      name: 'User',
      username: 'mega_user',
      email: 'mega_user@some.site',
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
      sex: 5,
      age: 22,
      password: '123456',
      password_confirmation: '123456'
    }
  end

  describe 'GET /new' do
    it 'renders user registration form' do
      get new_user_registration_path
      expect(response).to be_successful
    end

    it 'renders registration page' do
      get new_user_registration_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post user_registration_path, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post user_registration_path, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response).to be_successful
      end

      it 'renders registration page' do
        get new_user_registration_path
        expect(response).to render_template(:new)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
