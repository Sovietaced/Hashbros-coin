class PoolWorkerController < ApplicationController

	def index
		@worker = PoolWorker.first.to_json
	end

	def show
		@worker = PoolWorker.find(params[:id]).to_json
	end
end
