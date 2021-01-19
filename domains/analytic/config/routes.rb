Analytic::Engine.routes.draw do
  namespace :v1 do
    namespace :charts do
      resources :boil_off_rate, only: [:index]
      resources :stage_trend1, only: [:index]
    end
  end
end
