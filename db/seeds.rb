# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Make test games
    game_count = 0
    
    while game_count > 500 do
      Game.create(title: "test_game_#{game_count}")
      game_count = game_count + 1
    end