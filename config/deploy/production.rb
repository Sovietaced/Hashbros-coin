role :all, "litecoin.hashbros.co.in", :primary => true, :no_release => false
set :deploy_to, "/var/www/Hashbros-coin"
set :rails_env, 'production'
set :branch, 'master'