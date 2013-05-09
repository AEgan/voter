class AddPhotoToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :photo, :string
  end
end
