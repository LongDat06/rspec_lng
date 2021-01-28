Ais::Engine.routes.draw do
  namespace :v1 do
    namespace :vessels do
      resources :info, only: [:index]
    end

    resources :trackings, only: [:index]
    resources :latest_positions, only: [:index]
    resources :vessels, only: [:create, :index, :update, :destroy]
    resources :plan_routes, only: [:index]
  end
end
