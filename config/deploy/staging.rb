# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server '10.68.11.28', user: 'guardian', roles: %w(web db app)

set :rails_env,       'staging'
set :branch,          ENV['BRANCH']
set :stage,           'staging'
set :deploy_to,       "/opt/#{fetch(:application)}"
set :puma_bind,       "unix:#{fetch(:deploy_to)}/shared/tmp/#{fetch(:application)}_puma.sock"
set :puma_state,      "#{fetch(:deploy_to)}/shared/tmp/pids/puma.state"
set :puma_pid,        "#{fetch(:deploy_to)}/shared/tmp/pids/puma.pid"
set :puma_access_log, "#{fetch(:deploy_to)}/shared/log/puma.access.log"
set :puma_error_log,  "#{fetch(:deploy_to)}/shared/log/puma.error.log"
set :linked_files,    %w{config/database.yml config/mongoid.yml config/newrelic.yml .env}
