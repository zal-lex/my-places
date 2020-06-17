# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Download', type: :request do
  describe 'GET /show' do
    context 'when user is admin' do
      let!(:user) { FactoryBot.create(:admin) }

      it 'generate PDF' do
        sign_in user
        get '/users/:id/download.pdf', headers: headers
        expect(response.header['Content-Type']).to include 'application/pdf'
      end

      it 'renders a page with statistics' do
        sign_in user
        get '/users/:id/download.pdf', headers: headers
        expect(response).to render_template('users/pdf.html.erb')
      end

      it 'renders a successful response' do
        sign_in user
        get '/users/:id/download.pdf', headers: headers
        expect(response).to be_successful
      end
    end

    context 'when user is not admin' do
      let!(:user) { FactoryBot.create(:user) }

      it 'does not generate PDF' do
        sign_in user
        get '/users/:id/download.pdf', headers: headers
        expect(response.header['Content-Type']).not_to include 'application/pdf'
      end

      it 'redirects to landing page' do
        sign_in user
        get '/users/:id/download.pdf', headers: headers
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
