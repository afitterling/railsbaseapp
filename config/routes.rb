require_relative "../webhooks/github"

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :devices, only: [:index, :create] do
    resources :device_access_tokens, only: :index
  end
  resources :log_data, only: [:index, :create, :show]

  get '/system_config/:key', to: 'system_config#show'
  post '/system_config/:key', to: 'system_config#update'

  mount Github.new => "/webhooks/github"
end
