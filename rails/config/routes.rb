Rails.application.routes.draw do
  get 'auth/login'
  get 'auth/logout'
  get 'auth/callback'
  get 'dashboard', to: 'dashboard#index'
  root 'welcome#index'
end
