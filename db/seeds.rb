# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Share.delete_all
PoolWorker.delete_all

(1..100).to_a.each do |i| 
	Share.create!(:rem_host => '24.188.55.241', :username => 'travisby.1', :our_result => 'Y', :upstream_result => 'N', :solution => '000006536e7f2cdcd652629673bf930d23d8a7c53f638711fd36cb0713329b13', :time => '2013-12-15 02:42:33', :difficulty => 16)
end

PoolWorker.create!(:account_id => 0, :username => 'travisby.1', :password => 'nig', :hashrate => 540, :difficulty => 16)