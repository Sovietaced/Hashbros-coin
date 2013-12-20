class SharesController < ApplicationController

	def index
		@share = Share.first.to_json
	end

	def show
		@share = Share.find(params[:id]).to_json
	end
end
