class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.string :name
      t.text :description
      t.integer :wins
      t.integer :times_played
      t.float :elo

      t.timestamps
    end
  end
end
