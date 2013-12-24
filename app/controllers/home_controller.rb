class HomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token

  def index
  end

  def deposit
    balance = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf getbalance hashbros 2>&1)
    if system("cd ~/.litecoin; litecoind -conf=coin.conf sendtoaddress #{params[:exchange_address]} #{balance}")
    	render :json => {:result => :success}
    else
    	render :json => {:result => :failure}
    end
  end

  # Start and Stop times in integer (string) epoch time
  def summary

    balance = %x(cd ~/.litecoin; litecoind -conf=coin.conf getbalance hashbros 2>&1)
  	balance = balance.strip
    
    # parse parameters to datetime objects
  	start = Time.at(params[:start].to_i)
  	stop = Time.at(params[:stop].to_i)

  	# find all shares within the range <3 rails
  	round_shares = Share.where(:time => start..stop)

  	num_round_shares_accepted = round_shares.where(:our_result => "Y").count
  	num_round_shares_rejected = round_shares.where(:our_result => "N").count

  	# determine the number of blocks found
  	blocks = round_shares.where(:upstream_result => "Y").count

  	# get a unique array of the workers involved
  	workers = round_shares.pluck(:username).uniq

  	work = {}

  	workers.each do |worker|
  		num_accepted = round_shares.where(:username => worker, :our_result => "Y").count
  		num_rejected = round_shares.where(:username => worker, :our_result => "N").count
  		# Calculate the percentage of work done, notice the float
  		percentage_of_work = num_accepted.to_f / num_round_shares_accepted
  		# Determine their reject rate for this round
  		reject_rate = num_rejected.to_f / (num_accepted + num_rejected)

  		work[worker] = {:accepted_shares => num_accepted, :rejected_shares => num_rejected, :percentage_of_work => percentage_of_work, :reject_rate => reject_rate}
  	end

  	render :json => {:total_shares => round_shares.count, :accepted_shares => num_round_shares_accepted, :rejected_shares => num_round_shares_rejected, :blocks => blocks, :work => work}
  end
end
