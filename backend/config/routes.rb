Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "api/v1", skip: [:registrations, :passwords, :omniauth_callbacks]

end
