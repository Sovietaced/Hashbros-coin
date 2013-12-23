class HomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token

  def index
  end

  def deposit
    balance = %x(cd ~/.litecoin; litecoind -conf=coin.conf getbalance hashbros 2>&1)
    if system("cd ~/.litecoin; litecoind -conf=coin.conf sendtoaddress #{params[:exchange_address]} #{balance}")
    	render :json => {:result => :success}
    else
    	render :json => {:result => :failure}
    end
  end

  # Start and Stop times in integer (string) epoch time
  def summary

  	# parse parameters to datetime objects
  	start = Time.at(params[:start].to_i)
  	stop = Time.at(params[:stop].to_i)

  	# find all shares within the range <3 rails
  	round_shares = Share.where(:time => start..stop)

  	render :json => round_shares
  end
end
