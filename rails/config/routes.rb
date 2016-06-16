Rails.application.routes.draw do
  resource :hooks, only: :create, defaults: { formats: :json }
end
