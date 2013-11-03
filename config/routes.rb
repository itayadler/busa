Busa::Application.routes.draw do
  get 'trips/:action', to: 'trips#show'
  resources :trips, only: [:index]
end
