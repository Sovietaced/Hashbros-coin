class CreateShares < ActiveRecord::Migration
  def change
  	if Rails.env.development?
	    create_table :shares do |t|
	   
		  t.string :rem_host
		  t.string :username
		  t.string :our_result
		  t.string :upstream_result 
		  t.string :reason
		  t.string :solution
		  t.timestamp :time
		  t.float :difficulty

      end
    end
  end
end
