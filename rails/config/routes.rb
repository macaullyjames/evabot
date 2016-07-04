Rails.application.routes.draw do
  root 'sessions#new'

  get 'welcome/index'
  get 'dashboard/index'
  resources :sessions, only: [:new, :create, :destroy]
end
