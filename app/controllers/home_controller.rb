class HomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token

  def index
  end

  def deposit
    
    balance = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf getbalance "" 2>&1)
    balance = balance.strip

    transfer_id = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf sendtoaddress #{params[:exchange_address]} #{balance} Hashbros)
    transfer_id = transfer_id.strip
    
    if $?.success?
      render :json => {:result => :success, :balance => balance, :txid => transfer_id}
    else
    	render :json => {:result => :failure, :balance => balance}
    end
  end

  # Worker hashrate and difficulty
  def worker_stats

    # We only care about active workers
    workers = PoolWorker.all
    
    stats = []

    workers.each do |worker|
      # We estimate the hash rate over the last 5 minutes
      last_five = (5.minutes.ago..Time.now)
      seconds_in_five = 300
      recent_shares = Share.where(:username => worker.username, :time => last_five)

      # Calculate the number of hashes with difficulty
      total_shares = 0
      recent_shares.each { |share| total_shares += share.difficulty }
      
      # Find hash rate and divid by 1 million to get megahashes.
      hashrate = (2 ** 16) * total_shares / (seconds_in_five * 1000000)
      
      stats.push({:username => worker.username, :hashrate => hashrate, :difficulty => worker.difficulty})
    end

    render :json => stats

  end

  # Start and Stop times in integer (string) epoch time
  def summary

    balance = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf getbalance "" 2>&1)
    balance = balance.strip
    
    # parse parameters to datetime objects
  	start = Time.at(params[:start].to_i)
  	stop = Time.at(params[:stop].to_i)

  	# find all shares within the range <3 rails
  	round_shares = Share.where(:time => start..stop)

  	num_round_shares_accepted = round_shares.where(:our_result => "Y").count
  	num_round_shares_rejected = round_shares.where(:our_result => "N").count

    reject_rate = (num_round_shares_rejected.to_f / round_shares.count) * 100
    
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

  		work[worker] = {:accepted_shares => num_accepted, :rejected_shares => num_rejected, :percentage_of_work => percentage_of_work, :reject_rate => reject_rate}
  	end

  	render :json => {:total_shares => round_shares.count, :accepted_shares => num_round_shares_accepted, :rejected_shares => num_round_shares_rejected, :blocks => blocks, :work => work, :coins => balance, :reject_rate => reject_rate}
  end
end
