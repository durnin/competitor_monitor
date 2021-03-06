# frozen_string_literal: true



Rails.application.routes.draw do
  root to: 'groups#index'
  resources :groups do
    resources :competitors, only: %i[new]
  end
  resources :competitors, only: %i[show create edit update destroy]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
end
