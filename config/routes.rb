Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: %i[omniauth_callbacks], controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations',
        passwords: 'api/v1/passwords'
      }

      resources :chat_rooms, only: %i[index create] do
        resources :chat_messages, only: %i[index create], shallow: true
      end

      resources :users, only: %i[index show update]
    end
  end
end
