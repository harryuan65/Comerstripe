# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#root'
  # post '/webhooks', to: 'webhooks#create'
  scope :stripe, controller: :stripe do
    post :webhooks
    post :create_checkout_session
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :orders
end
