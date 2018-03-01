require_relative "../webhooks/github"

Rails.application.routes.draw do
  resources :users, only: [:create]

  namespace :users do
    resource :access_token, only: [:create, :destroy] do
      get 'read_only', to: 'access_tokens/read_only#index'
    end
    resources :streams, only: [:index, :create, :show, :update] do
      resources :webhooks, only: [:create]
    end
    resources :webhooks, only: [:index, :update, :destroy]
  end

  namespace :streams do
    resources :log_data, only: [] do
      resources :images, only: [:index, :create]
    end
  end

  resources :devices, only: [] do
    resources :device_access_tokens, only: :index
  end

  resources :devices, path: 'streams', only: [] do
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

  resources :devices, only: [:index, :create, :show, :update], controller: 'users/streams'
  resources :devices, path: 'streams', only: [:index, :create, :show, :update], controller: 'users/streams'
end
