Rails.application.routes.draw do
  mount Ais::Engine => 'ais'
  mount Weather::Engine => 'weather'
end
