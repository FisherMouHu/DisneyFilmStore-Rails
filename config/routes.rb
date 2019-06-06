Rails.application.routes.draw do
  get 'access/new'
  get 'access/create'
  get 'access/destroy'
  get 'admin/index'
  resources :users
  resources :orders
  resources :lineitems
  resources :carts
  get 'shopper/index'
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "shopper#index", as: "shopper"

  get '/admin', to: "admin#index", as: "admin"
  get '/login', to: "access#new", as: "login"
  post '/access/new', to: "access#create"   # POST '/login'
  delete '/logout', to: "access#destroy", as: "logout"
end
