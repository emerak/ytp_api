Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope 'api' do
    namespace :v1 do

      post 'login', to: 'authentications#create'

      resources :registrations, only: :create
      resources :deposits, only: :create
      resources :transfers, only: :create
    end
  end
end
