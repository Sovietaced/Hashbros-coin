servers = [
	"ps-goldcoin.hashbros.co.in", 
	"ps-globalcoin.hashbros.co.in", 
	"ps-digitalcoin.hashbros.co.in",  
	"ps-fastcoin.hashbros.co.in", 
	"ps-casinocoin.hashbros.co.in", 
	"ps-grandcoin.hashbros.co.in", 
	"ps-franko.hashbros.co.in",
	"ps-luckycoin.hashbros.co.in",
    "ps-alphacoin.hashbros.co.in",
	"ps-stablecoin.hashbros.co.in",
	"ps-kittehcoin.hashbros.co.in"]
servers.each do |server|
	role :web, server                # Your HTTP server, Apache/etc
	role :app, server                # This may be the same as your `Web` server
	role :db, server, primary: true  # This is where Rails migrations will run
end
set :deploy_to, "/var/www/Hashbros-coin"
set :rails_env, 'production'
set :branch, 'master'