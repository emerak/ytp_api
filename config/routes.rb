Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope 'api' do
    namespace :v1 do
      post 'login', to: 'authentications#create'
    end
  end
end
