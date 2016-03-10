class AddApiIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :api_id, :string
  end
end
