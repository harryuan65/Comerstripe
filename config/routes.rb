# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#root'
  resources :webhooks, only: %i[create]
  # post '/webhooks', to: 'webhooks#create'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :orders
end
