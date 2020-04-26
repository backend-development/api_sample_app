# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :money_transactions
  resources :users
  get 'static/help'
  get 'static/privacy'

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy]
    end
  end

  root to: 'static#home'
end
