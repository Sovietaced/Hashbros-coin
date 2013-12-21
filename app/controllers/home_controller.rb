class HomeController < ApplicationController
  def index
  end

  # Dump to exchange
  def dump
  	# Address of echange wallet
  	@address = params[:address]

  	# Fork command of <coind>d -conf=coin.conf send <@address>

  end
end
