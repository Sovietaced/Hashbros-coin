require 'capistrano/ext/multistage'

set :application, "Hashbros-coin"
set :stages, ["production"]
set :default_stage, "production"

set :scm, :git
set :repository,  "git@github.com:Sovietaced/Hashbros-coin.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "deployer"
set :use_sudo, false

# So sudo password doesn't throw errors
default_run_options[:pty] = true