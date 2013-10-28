Busa::Application.routes.draw do
  resources :routes, only: [:index]
end
