Rails.application.routes.draw do
  get 'auth/login'
  get 'auth/logout'
  get 'welcome/index'
  get 'dashboard/index'
  resource :session, only: [:new, :create, :destroy]
  root 'welcome#index'
end
