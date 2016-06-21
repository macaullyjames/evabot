Rails.application.routes.draw do
  root 'welcome#index'

  resources :welcome,   only: [:index]
  resources :dashboard, only: [:index]
  resources :sessions,  only: [:new, :create, :destroy]
end
