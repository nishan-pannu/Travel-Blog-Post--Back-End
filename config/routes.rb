Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      # authentication routes
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      get 'current_user', to: 'sessions#current_user'

      # user routes
      post 'signup', to: 'users#create'
      get 'profile', to: 'users#show'

      resources :users, only: [:show] do
        resources :posts, only: [:index]
      end

      # post routes
      resources :posts, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :search  # Add this line for search functionality
        end
        
        # day routes
        resources :days, only: [:index, :create, :destroy]
        # rating routes
        resource :ratings, only: [:create, :show, :update, :destroy]
      end

      resources :posts do
        resources :comments, only: [:index, :create, :destroy]
        member do
          post 'like'
          delete 'unlike'
        end
      end

    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end