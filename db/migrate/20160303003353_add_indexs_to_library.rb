class AddIndexsToLibrary < ActiveRecord::Migration
  def change
    add_index :libraries, [:user_id, :game_id], unique: true
  end
end
