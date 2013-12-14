set :host, "litecoin.hashbros.co.in", "galaxycoin.hashbros.co.in"
role :web, host                # Your HTTP server, Apache/etc
role :app, host                # This may be the same as your `Web` server
role :db, host, primary: true  # This is where Rails migrations will run
set :deploy_to, "/var/www/Hashbros-coin"
set :rails_env, 'production'
set :branch, 'master'