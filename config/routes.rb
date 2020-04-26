# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' # in all environments!

  resources :money_transactions

  devise_for :users
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end
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
