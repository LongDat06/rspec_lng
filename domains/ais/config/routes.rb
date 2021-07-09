Ais::Engine.routes.draw do
  namespace :v1 do
    namespace :vessels do
      resources :info, only: [:index]
      resources :non_targets, only: [:create]
    end

    namespace :ecdis do
      namespace :points do
        resources :original_eta, only: [:create]
      end
      resources :routes, only: [:index]
      get 'routes/point_routes', to: 'routes#point_routes'
      resources :points, only: [:index]
    end

    resources :trackings, only: [:index]
    resources :latest_positions, only: [:index]
    resources :vessels, only: [:create, :index, :update, :destroy]
    resources :plan_routes, only: [:index]
    resources :closest_destinations, only: [:index]
  end
end
