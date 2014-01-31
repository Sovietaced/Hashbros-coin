class PoolWorker < ActiveRecord::Base
	self.table_name = "pool_worker"
	default_scope { order(:id)}
end
