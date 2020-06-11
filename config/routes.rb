# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users do
    resources :fav_places, only: %i(index), controller: 'users/fav_places'
    resources :places, only: %i(index create destroy), controller: 'users/places' do
      resource :likes, only: %i(create destroy), controller: 'users/places/likes'
    end
    member do
      get :following
    end
  end
  resources :friendships, only: [:create, :destroy]

  root to: 'users#index'
end
