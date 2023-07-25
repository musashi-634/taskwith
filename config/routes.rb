Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :home, only: :index
  devise_for :users

  namespace :projects do
    resources :archived, only: :index
  end
  resources :projects do
    resources :tasks
  end
end
