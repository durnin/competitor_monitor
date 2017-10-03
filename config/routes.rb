# frozen_string_literal: true



Rails.application.routes.draw do
  root to: 'groups#index'
  resources :groups do
    resources :competitors, only: %i[new]
  end
  resources :competitors, only: %i[show create edit]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
end
