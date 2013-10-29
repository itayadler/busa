Busa::Application.routes.draw do
  resources :trips, only: [:index, :show]
end
