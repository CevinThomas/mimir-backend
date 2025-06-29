Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  get "/users/google_login", to: 'omniauth#google_login'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get '/health', to: 'api/client/v1/users#health'

  devise_scope :user do
    get  '/users/confirmations/confirmation', to: 'users/confirmations#show'
    post '/users/registrations', to: 'users/registrations#create'
    post '/users/sessions', to: 'users/sessions#create'
    delete '/users/sessions', to: 'users/sessions#destroy'
    get '/logged_in', to: 'users/omniauth_callbacks#logged_in', as: :logged_in
    get '/login_failed', to: 'users/omniauth_callbacks#login_failed', as: :login_failed
  end

  resources :promote_requests, only: %i[index create update destroy] do
    collection do
      patch :approve_promote
    end
  end

  resources :folders, only: %i[index create update destroy show]

  # TODO: Make better API design. This is a temporary solution
  resources :decks, only: %i[index create update destroy show] do
    resources :cards, only: %i[create update destroy] do
      resources :choices, only: %i[create update destroy]
    end
    member do
      post :share
      post :request_promote
      get :share_with
      delete :shared_session
      post :favorite
      delete :remove_featured
      patch :viewed_account_decks
      post :publish
    end

    collection do
      get :accept_share
      get :shared
      get :account_decks
      get :new_decks
      get :featured
      get :favorites
      patch :checked
    end
  end
  resources :deck_sessions, only: %i[index create show destroy] do
    member do
      get :cards
      post :exclude_card
      delete :reset_session
      post :copy
      post :answer_question
      post :complete
      get :percentage
    end
  end

  resources :accounts, only: %i[update destroy] do
    collection do
      get :show
    end
  end

  resources :users, only: %i[show update destroy] do
    member do
      post :reset_password
    end
    collection do
      get :for_current_account
      get :verified
      get :user_info
    end
  end

  resources :omniauth, only: [:create] do
    collection do
      get :omniauth_window
      post :poll_success
      delete :expire
    end
  end
end
