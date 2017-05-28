require_relative "../webhooks/github"

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :devices, only: :create
  resources :log_data, only: [:index, :create, :show]

  mount Github.new => "/webhooks/github"
end
