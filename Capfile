# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
require 'capistrano/rails'
require 'capistrano/bundler'
require "capistrano/rails/migrations"
require 'capistrano/rake'
require 'capistrano/rbenv'
require 'capistrano/puma'
require 'capistrano/puma/nginx'
require 'whenever/capistrano'
require 'capistrano/sidekiq'

install_plugin Capistrano::Puma

task :use_systemd do
	install_plugin Capistrano::Sidekiq
  install_plugin Capistrano::Puma::Systemd
	install_plugin Capistrano::Sidekiq::Systemd
end

task 'production' => [:use_systemd]

# Load custom tasks from `lib/capistrano/tasks` if you have any defined

install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
