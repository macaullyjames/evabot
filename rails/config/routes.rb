Rails.application.routes.draw do
  get 'auth/login'
  get 'auth/logout'
  get 'welcome/index'
  get 'dashboard/index'
  root 'welcome#index'
end
