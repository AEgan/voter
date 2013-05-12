class AddActiveToContests < ActiveRecord::Migration
  def change
  	add_column :contests, :active, :boolean
  end
end
