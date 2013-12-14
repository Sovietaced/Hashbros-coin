require "capistrano/ext/multistage"
require "bundler/capistrano"
require "rvm/capistrano"
require 'secret_token_replacer/recipes'

set :application, "Hashbros-coin"
set :stages, ["production"]
set :default_stage, "production"

default_run_options[:pty] = true

set :scm, :git
set :repository,  "git@github.com:Sovietaced/Hashbros-coin.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "deployer"
set :use_sudo, false

# After restart the web server
after "deploy", "deploy:restart_nginx" 

# Small recipe
namespace :deploy do
  task :restart_nginx, :roles => :web do
    run "touch #{ current_path }/tmp/restart.txt"
  end
end