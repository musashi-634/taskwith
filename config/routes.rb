Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  shallow do
    root 'home#index'
    resources :home, only: :index

    devise_for :users, controllers: { invitations: 'users/invitations' }
    get 'users', to: 'users#show'

    resource :organization

    namespace :projects do
      resources :archived, only: :index
    end
    resources :projects do
      namespace :tasks do
        resources :sortings, only: :update
      end
      resources :tasks
    end
  end

  resolve('Organization') { [:organization] } # 単数形リソースでform_withを機能させるため
end
