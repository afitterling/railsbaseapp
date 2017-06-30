require_relative "../webhooks/github"

Rails.application.routes.draw do
  resources :users, only: [:create]

  namespace :users do
    resource :access_token, only: [:create, :destroy]
    resources :streams, only: [:index, :create]
  end

  resources :devices, only: [:update] do
    resources :device_access_tokens, only: :index
  end

  resources :devices, path: 'streams', only: [:update] do
    resources :device_access_tokens, only: :index
  end

  resources :log_data, only: [:index, :create, :show]
  resources :aggregate_log_data, only: [:index]

  get '/system_config/:key', to: 'system_config#show'
  post '/system_config/:key', to: 'system_config#update'
  get '/profile', to: 'users#profile', as: :user_profile

  mount Github.new => "/webhooks/github"

  # Deprecated routes
  post '/users/sign_in', to: 'users/access_tokens#create'
  delete '/users/sign_out', to: 'users/access_tokens#destroy'

  resources :devices, only: [:index, :create], controller: 'users/streams'
  resources :devices, path: 'streams', only: [:index, :create], controller: 'users/streams'
end
