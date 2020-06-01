# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :users do
    resources :places, only: %i(index create), controller: 'users/places'
    member do
      get :following
    end
  end
  resources :friendships, only: [:create, :destroy]

  root to: 'users#index'
end
