require "capistrano/ext/multistage"
require "bundler/capistrano"
require "rvm/capistrano"

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

# Run migrations after deploying
after "deploy:update_code", "deploy:migrate"

namespace :deploy do
  # Restarts nginx
  task :restart_nginx, :roles => :web do
    run "touch #{ current_path }/tmp/restart.txt"
  end

  # Only precompile modified assets
  namespace :assets do
        task :precompile, :roles => :web, :except => { :no_release => true } do
          from = source.next_revision(current_revision)
          if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
            run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
          else
            logger.info "Skipping asset pre-compilation because there were no asset changes"
          end
      end
    end
end