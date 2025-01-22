Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  get '/health', to: 'api/client/v1/users#health'

  devise_scope :user do
    get  '/users/confirmations/confirmation', to: 'users/confirmations#show'
    post '/users/registrations', to: 'users/registrations#create'
    post '/users/sessions', to: 'users/sessions#create'
    delete '/users/sessions', to: 'users/sessions#destroy'
  end

  namespace :api do
    namespace :admin do
      namespace :v1 do
        resources :decks, only: [:index, :create, :update, :destroy]
      end
    end
  end
end
