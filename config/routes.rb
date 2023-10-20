Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  shallow do
    root 'home#index'
    resources :home, only: :index

    devise_for(
      :users,
      controllers: {
        invitations: 'users/invitations',
        registrations: 'users/registrations',
      }
    )
    devise_scope :user do
      post 'users/guests/sign_in', to: 'users/sessions/guests#create', as: 'users_guest_session'
    end
    namespace :users do
      resource :account, only: :show
    end

    resource :organization

    namespace :projects do
      resources :archives, only: %i(index create destroy)
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
