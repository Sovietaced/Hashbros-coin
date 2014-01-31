class AddTimestamps < ActiveRecord::Migration
  def change
  	add_column :shares, :created_at, :datetime
    add_column :shares, :updated_at, :datetime

    add_column :pool_worker, :created_at, :datetime
    add_column :pool_worker, :updated_at, :datetime
  end
end
