# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :users do
    resources :places, only: %i(index create), controller: 'users/places'
  end

  root to: 'users#index'
end
