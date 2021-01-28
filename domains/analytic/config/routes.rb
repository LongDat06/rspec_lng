Analytic::Engine.routes.draw do
  namespace :v1 do
    namespace :charts do
      resources :boil_off_rate, only: [:index]
      resources :stage_trend1, only: [:index]
      resources :stage_trend21, only: [:index]
      resources :tank_volume, only: [:index]
      resources :tank_equator, only: [:index]
      resources :tank_liquid_temp, only: [:index]
      resources :press, only: [:index]
      resources :stage_trend31, only: [:index]
      resources :stage_trend32, only: [:index]
    end
  end
end
