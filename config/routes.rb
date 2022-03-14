Rails.application.routes.draw do
  root "users#index"
  resources :readings
  resources :users
end
