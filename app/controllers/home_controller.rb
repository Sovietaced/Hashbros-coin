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
   	balance = %x(cd ~/.litecoin; litecoind -conf=coin.conf getbalance hashbros 2>&1)
   	@blah = params
   	#@blah = %x(cd ~/.litecoin; litecoind -conf=coin.conf sendtoaddress #{params[:exchange_address]} #{balance} 2>&1)
  end 
end
