# frozen_string_literal: true

namespace :anycable do
  desc 'Stop websocket server'
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, fetch(:anycable_systemctl_service_name)
    end
  end
  desc 'Start websocket server'
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, fetch(:anycable_systemctl_service_name)
    end
  end
  desc 'Restart websocket server'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, fetch(:anycable_systemctl_service_name)
    end
  end
end
