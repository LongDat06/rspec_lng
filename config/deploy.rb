# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "lng-backend"
set :repo_url, "git@github.com:vietgurus/lng-backend.git"
set :ssh_options,     { forward_agent: true, keys: %w(~/.ssh/id_rsa.pub) }
set :puma_role,       :web
set :puma_threads,    [4, 4]
set :puma_workers,     2
set :keep_releases,    5
set :rbenv_type,      :user
set :rbenv_prefix,    "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins,  %w{rake gem bundle ruby rails }
set :rbenv_roles,     :all
set :rbenv_ruby,      '3.0.0'


set :format,          :pretty
set :log_level,       :debug

set :pty,             true
set :linked_files,    %w{config/database.yml config/mongoid.yml}
set :linked_dirs,     %w{log tmp/pids tmp/cache tmp/sockets}
set :bundle_binstubs, nil

Rake::Task['deploy:compile_assets'].clear_actions

namespace :deploy do
  desc "restart puma"
  task :restart_puma do
    on roles (fetch(:puma_role)) do |role|
      within current_path do
        with rack_env: fetch(:puma_env) do
          invoke 'puma:stop'
          sleep 2
          invoke 'puma:start_without_daemon'
        end
      end
    end
  end

  desc 'Stop monit before stop sidekiq'
  task :stop_monit do
    on roles(:app) do
      execute "sudo /etc/init.d/monit stop"
    end
  end

  desc 'Start monit'
  task :start_monit do
    on roles(:app) do
      execute "sudo /etc/init.d/monit start"
    end
  end

  # before :starting,  'deploy:stop_monit'
  # after :finishing, :restart_puma
  # after 'deploy:finished', 'deploy:start_monit'
end
