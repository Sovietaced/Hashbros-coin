class SharesController < ApplicationController

	def show
		@share = Share.find(params[:id])
	end
end
