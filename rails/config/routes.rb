Rails.application.routes.draw do
  root 'sessions#new'

  get 'welcome/index'
  get 'dashboard/index'
  resource :session, only: [:new, :create, :destroy]
end
