class AddEpidToGames < ActiveRecord::Migration
  def change
    add_column :games, :epid, :string
  end
end
