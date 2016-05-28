class AddPlatformsToGames < ActiveRecord::Migration
  def change
    add_column :games, :platforms, :text
  end
end
