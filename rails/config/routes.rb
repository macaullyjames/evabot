Rails.application.routes.draw do
  resources :repos, only: :update

  get 'auth/login',  as: 'login'
  get 'auth/logout', as: 'logout'
  get 'auth/callback'

  get 'dashboard', to: 'dashboard#index'
  get 'settings', to: 'settings#index'
  root 'welcome#index'
end
