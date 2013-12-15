class PoolWorkerController < ApplicationController

	def show
		@share = PoolWorker.find(params[:id])
	end
end
