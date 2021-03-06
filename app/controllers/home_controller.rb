class HomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token

  def index
  end

  def deposit

    transfer_id = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf sendtoaddress #{params[:exchange_address]} #{params[:amount]} 2>&1)
    transfer_id = transfer_id.strip
    
    if $?.success?
      render :json => {:result => :success, :txid => transfer_id}
    else
    	render :json => {:result => :failure}
    end
  end

  # Worker hashrate and difficulty for shares created in the last 5 minutes
  def worker_stats

    # We estimate the hash rate over the last 5 minutes
    last_five = (5.minutes.ago..Time.now)
    seconds_in_five = 300;

    # Get shares in the last 5 mins
    recent_shares = Share.where(:time => last_five)
    
    workers = {}
    
    # Calculate numbers of shares and difficulty
    recent_shares.each do |share|
      # Update hash if key found
      if workers.has_key?(share.username)
        hash = workers[share.username]
        workers[share.username][:shares] = hash[:shares] + share.difficulty
        workers[share.username][:difficulty] = share.difficulty
      # Create Hash
      else
        workers[share.username] = {:shares => 0, :difficulty => share.difficulty} 
      end
    end

    stats = []

    # Calculate hash rates from number of shares
    workers.keys.each do |username|
      worker = workers[username]
      # Find hash rate and divide by 1 million to get megahashes.
      hashrate = (2 ** 16) * worker[:shares].to_f / (seconds_in_five * 1000000)
      stats.push({:username => username, :hashrate => hashrate, :difficulty => worker[:difficulty]})
    end

    render :json => stats

  end

  def blocks

    start = Time.at(params[:start].to_i)
    stop = Time.at(params[:stop].to_i)
    time = start..stop

    ''' Block data '''
    api_call = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf listtransactions "" 10000 2>&1)
    # Need to verify deposit was successful
    transaction_json = ActiveSupport::JSON.decode(api_call)

    blocks = []

    transaction_json.each { |transaction| blocks.push(transaction) if transaction["category"] != "send" and time.cover? Time.at(transaction["time"]).to_datetime }
    
    render :json => blocks
  end

  def coins

    ''' Block data '''
    api_call = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf getmininginfo 2>&1)
    info_json = ActiveSupport::JSON.decode(api_call)
    
    info = {:blocks => info_json["blocks"], :difficulty => info_json["difficulty"], :network_hash_rate => info_json["networkhashps"]}
    
    render :json => info
  end

  # Start and Stop times in integer (string) epoch time
  def summary
    
    # parse parameters to datetime objects
  	start = Time.at(params[:start].to_i)
  	stop = Time.at(params[:stop].to_i)
    time = start..stop

  	# find all shares within the range <3 rails
  	round_shares = Share.where(:time => start..stop)

  	num_round_shares_accepted = round_shares.where(:our_result => "Y").reduce(0) { |sum, share| sum + share.difficulty}
  	num_round_shares_rejected = round_shares.where(:our_result => "N").reduce(0) { |sum, share| sum + share.difficulty}

    round_reject_rate = (num_round_shares_rejected.to_f / (num_round_shares_accepted + num_round_shares_rejected)) * 100


    ''' Worker data '''
    work = {}

    round_shares.each do |share|
      # Update hash if key found
      if work.has_key?(share.username)
        hash = work[share.username]
        if share.our_result == "Y"
          work[share.username][:accepted_shares] = hash[:accepted_shares] + share.difficulty
        else
          work[share.username][:rejected_shares] = hash[:rejected_shares] + share.difficulty
        end
      # Create Hash
      else
        if share.our_result == "Y"
          work[share.username] = {:accepted_shares => share.difficulty, :rejected_shares => 0}
        else
          work[share.username] = {:accepted_shares => 0, :rejected_shares => share.difficulty} 
        end
      end
    end

    work.keys.each do |username|
      reject_rate = work[username][:rejected_shares].to_f / (work[username][:accepted_shares] + work[username][:rejected_shares])
      # Calculate the percentage of work done, notice the float
      percentage_of_work = work[username][:accepted_shares].to_f / num_round_shares_accepted

      work[username][:percentage_of_work] = percentage_of_work
      work[username][:reject_rate] = reject_rate
    end

    render :json => {:total_shares => (num_round_shares_accepted + num_round_shares_rejected), :accepted_shares => num_round_shares_accepted, :rejected_shares => num_round_shares_rejected, :work => work, :reject_rate => round_reject_rate}
  end

  # Run two commands and make sure they dont return errors
  def status
    
    # Check the daemon
    %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf getinfo 2>&1)
    render :json => {:result => :failure} if not $?.success?
    
    # Grep for stratum
    if `ps aux | grep twist[d]` == ""
      render :json => {:result => :failure}
    end

    # Everything must be working
    render :json => {:result => :success}
  end

   def validate_address

    api_call = %x(cd #{params[:dir]}; #{params[:daemon]} -conf=coin.conf validateaddress #{params[:address]} 2>&1)
    address_json = ActiveSupport::JSON.decode(api_call)
    
    if address_json["isvalid"]
      render :json => {:result => :success}
    else
      render :json => {:result => :failure}
    end
  end
end
