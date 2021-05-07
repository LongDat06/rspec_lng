# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server '10.29.4.195', user: 'guardian', roles: %w(web db app)

set :rails_env,       'production'
set :branch,          ENV['BRANCH']
set :stage,           'production'
set :deploy_to,       "/opt/#{fetch(:application)}"
set :puma_bind,       "unix:#{fetch(:deploy_to)}/shared/tmp/#{fetch(:application)}_puma.sock"
set :puma_state,      "#{fetch(:deploy_to)}/shared/tmp/pids/puma.state"
set :puma_pid,        "#{fetch(:deploy_to)}/shared/tmp/pids/puma.pid"
set :puma_access_log, "#{fetch(:deploy_to)}/shared/log/puma.access.log"
set :puma_error_log,  "#{fetch(:deploy_to)}/shared/log/puma.error.log"
set :linked_files,    %w{config/database.yml config/mongoid.yml .env}
