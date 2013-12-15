class PoolWorkerController < ApplicationController

	def show
		@worker = PoolWorker.find(params[:id])
	end
end
