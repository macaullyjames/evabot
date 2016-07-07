Rails.application.routes.draw do
  get 'auth/login'
  get 'auth/logout'
  get 'dashboard', to: 'dashboard#index'
  root 'welcome#index'
end
