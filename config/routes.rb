require_relative "../webhooks/github"

Rails.application.routes.draw do
  resources :users, only: [:create]
  post '/users/sign_in', to: 'access_tokens#create'
  delete '/users/sign_out', to: 'access_tokens#destroy'

  resources :devices, only: [:index, :create, :update] do
    resources :device_access_tokens, only: :index
  end

  resources :devices, path: 'streams', only: [:index, :create, :update] do
    resources :device_access_tokens, only: :index
  end

  resources :log_data, only: [:index, :create, :show]
  resources :aggregate_log_data, only: [:index]

  get '/system_config/:key', to: 'system_config#show'
  post '/system_config/:key', to: 'system_config#update'
  get '/profile', to: 'users#profile', as: :user_profile

  mount Github.new => "/webhooks/github"
end
