Rails.application.routes.draw do
  mount Ais::Engine => 'ais'
  mount Weather::Engine => 'weather'
  mount Analytic::Engine => 'analytic'

  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end

  draw :sidekiq

end
