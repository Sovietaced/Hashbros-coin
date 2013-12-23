class HomeController < ApplicationController
  def index
  end

  # Dump to exchange
  def dump
  	# Address of echange wallet
  	@address = params[:address]

  	# Fork command of <coind>d -conf=coin.conf send <@address>

  end

  def test
   	@blah = %x(cd ~/.litecoin; litecoind -conf=coin.conf getinfo 2>&1)
	#{}%x(socat tcp-listen:3333 tcp-connect:#{new_round_coin.name}.hashbros.co.in:3333 > log/switch.log 2>&1 &)
  end 
end
