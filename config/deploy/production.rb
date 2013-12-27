servers = ["dogecoin.hashbros.co.in", "grandcoin.hashbros.co.in", "ps-franko.hashbros.co.in", "frank.hashbros.co.in", "ps-alphacoin.hashbros.co.in"]
servers.each do |server|
	role :web, server                # Your HTTP server, Apache/etc
	role :app, server                # This may be the same as your `Web` server
	role :db, server, primary: true  # This is where Rails migrations will run
end
set :deploy_to, "/var/www/Hashbros-coin"
set :rails_env, 'production'
set :branch, 'master'