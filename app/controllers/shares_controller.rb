class SharesController < ApplicationController

	def index
		@share = Share.first.to_json
		@time = Share.first.time
	end

	def show
		@share = Share.find(params[:id]).to_json
	end
end
