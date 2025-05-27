Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "api/v1", skip: [:registrations, :passwords, :omniauth_callbacks]

  namespace :api do
    namespace :v1 do
      resources :groups, only: [:index]
      resources :attendances, only: [:index, :create, :update, :destroy]
      resource :profile, only: [:show, :update]
      post "login", to: "auth#login"
    end
  end
end
