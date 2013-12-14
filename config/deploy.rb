require 'capistrano/ext/multistage'

set :application, "Hashbros-coin"
set :stages, ["production"]
set :default_stage, "production"

set :scm, :git
set :scm_user, "Sovietaced/Hashbros-coin"
set :repository,  "git@github.com:Sovietaced/Hashbros-coin.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "deployer"
set :use_sudo, false

# So sudo password doesn't throw errors
default_run_options[:pty] = true

# After restart the web server
after "deploy", "deploy:restart_daemons" 