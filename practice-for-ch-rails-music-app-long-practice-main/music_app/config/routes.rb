Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "users#new"
  resources :users, only: [:new, :create, :show]
  resource :sessions, only: [:create, :destroy, :new]
end
