Rails.application.routes.draw do
  root 'sessions#new'

  resources :welcome,   only: [:index]
  resources :dashboard, only: [:index]
  resources :sessions,  only: [:new, :create, :destroy]
end
