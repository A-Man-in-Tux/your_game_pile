require 'test_helper'

class LibraryTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:foo)
    
    @user1 = users(:foo2)
    @game = games(:foo_game)
  end
  test "fixtures" do
    assert User.find(@user.id)
    assert Game.find(@game.id)
  end
  test "games are unique" do
    @user.add(@game)
    assert_no_difference '@user.games.count' do
      @user.librarys.create(game: @game)
    end
    
  end
  
  test "same game can be add to diffent users library" do
    #add game to first library
    @user.add(@game)
    #add same game to secound library
    @user1.add(@game)
    assert @user1.games.include?(@game)
    assert @user1.librarys.find_by(game_id: @game.id)
  end
  
  test "games can be added" do
    @user.add(@game)
    assert @user.games.include?(@game)
  end
  
  test "games can be removed" do
    @user.add(@game)
    @user.remove(@game)
    assert_not @user.games.include?(@game)
  end
  
end
