Analytic::Engine.routes.draw do
  namespace :v1 do
    namespace :charts do
      resources :stage_boil_off_rate, only: [:index]
      resources :stage_trend1, only: [:index]
      resources :stage_trend21, only: [:index]
      resources :stage_tank_volume, only: [:index]
      resources :stage_tank_equator, only: [:index]
      resources :stage_tank_liquid_temp, only: [:index]
      resources :stage_press, only: [:index]
      resources :stage_trend31, only: [:index]
      resources :stage_trend32, only: [:index]
      resources :stage_trend33, only: [:index]
      resources :xdf_trend1, only: [:index]
      resources :xdf_trend21, only: [:index]
      resources :xdf_boil_off_rate, only: [:index]
    end
  end
end
