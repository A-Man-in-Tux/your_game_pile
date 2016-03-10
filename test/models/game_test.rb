require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = Game.new(title: "foo game", api_id: 7342970974890489)
  end
  
  test "should be valid" do
    assert @game.valid?
  end
  
  test "api_id should be present" do
    @game.api_id = "    "
    assert_not @game.valid?
  end
  
  test "api_id should be unique" do
    duplicate_game = @game.dup
    @game.save
    assert_not duplicate_game.valid?
  end
end
