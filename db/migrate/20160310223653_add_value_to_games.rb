class AddValueToGames < ActiveRecord::Migration
  def change
    add_monetize :games, :price, amount: { null: true, default: nil }
  end
end
