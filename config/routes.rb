Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :home, only: :index
  devise_for :users
  resources :projects
end
