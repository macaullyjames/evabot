Rails.application.routes.draw do
  get 'users/new'

  resource :hooks, only: :create, defaults: { formats: :json }
end
