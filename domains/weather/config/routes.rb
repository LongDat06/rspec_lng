Weather::Engine.routes.draw do
  root to: 'welcome#index'

  namespace :v1 do
    resources :marine, only: [:index]
  end
end
