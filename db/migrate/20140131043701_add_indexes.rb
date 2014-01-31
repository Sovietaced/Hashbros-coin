class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :shares, :username
  	add_index :shares, :our_result
  	add_index :shares, :time

  	add_index :pool_worker, :username
  end
end
