class Share < ActiveRecord::Base
	default_scope { order(:id)}
end
