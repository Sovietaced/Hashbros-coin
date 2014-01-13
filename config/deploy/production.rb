servers = ["ps-anoncoin.hashbros.co.in", "ps-netcoin.hashbros.co.in", "ps-digitalcoin.hashbros.co.in", "ps-dogecoin.hashbros.co.in", "ps-fastcoin.hashbros.co.in", "ps-worldcoin.hashbros.co.in", "ps-spots.hashbros.co.in", "ps-lottocoin.hashbros.co.in", "ps-casinocoin.hashbros.co.in", "ps-grandcoin.hashbros.co.in", "ps-franko.hashbros.co.in"]
servers.each do |server|
	role :web, server                # Your HTTP server, Apache/etc
	role :app, server                # This may be the same as your `Web` server
	role :db, server, primary: true  # This is where Rails migrations will run
end
set :deploy_to, "/var/www/Hashbros-coin"
set :rails_env, 'production'
set :branch, 'master'