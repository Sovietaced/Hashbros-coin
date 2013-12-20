class CreatePoolWorker < ActiveRecord::Migration
  def change
  	if Rails.env.development?
      create_table :pool_worker do |t|
    	t.integer :account_id 
    	t.string :username
    	t.string :password
    	t.integer :hashrate
    	t.float :difficulty
      end
    end
  end
end
