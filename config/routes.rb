Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'cats#index'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  delete "/sessions.:session_id", to: "sessions#destroy_remote"
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new , :create, :show]
  # Defines the root path route ("/")
  # root "posts#index"
  resources :cats, except:[:destroy] do
    resources :cat_rental_requests, only: [:new]
  end
  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post 'approve'
      post 'deny'
    end
  end
end
