class HomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token

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
    if system("cd ~/.litecoin; litecoind -conf=coin.conf sendtoaddress #{params[:exchange_address]} #{balance}")
    	respond_with({:result => :success})
    else
    	respond_with({:result => :failure})
    end
  end 
end
