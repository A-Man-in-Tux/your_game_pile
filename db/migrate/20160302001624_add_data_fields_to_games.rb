class AddDataFieldsToGames < ActiveRecord::Migration
  def change
    add_column :games, :api_url, :string
    add_column :games, :image_url, :string
    add_column :games, :api_data, :text
  end
end
