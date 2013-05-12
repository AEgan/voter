class AddContestIdToCompetitor < ActiveRecord::Migration
  def change
  	add_column :competitors, :contest_id, :integer
  end
end
