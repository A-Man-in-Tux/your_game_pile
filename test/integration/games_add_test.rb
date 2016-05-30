require 'test_helper'

class GamesAddTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foo)
    @other_user = users(:foo2)
  end

  test 'should redirect to index after game added' do
    log_in_as(@user)
    get add_path
    post_via_redirect games_path,  game: { title: 'foo game', api_id: '7342970974890489' }
    assert_template 'games/index'
  end

  test 'game should be created' do
    log_in_as(@user)
    get add_path
    assert_difference 'Game.count', 1 do
      post_via_redirect games_path,  game: { title: 'foo game', api_id: '7342970974890489' }
    end
  end

  test 'game should be add to user library' do
    log_in_as(@user)
    get add_path
    assert_difference '@user.games.count', 1 do
      post_via_redirect games_path,  game: { title: 'foo game', api_id: '7342970974890489' }
    end
  end

  test 'game should be removed form library but not database' do
    log_in_as(@user)
    get add_path
    post_via_redirect games_path,  game: { title: 'foo game', api_id: '7342970974890489' }
    assert_difference '@user.games.count', -1 do
      @game = Game.find_by(api_id: '7342970974890489')
      get game_path(@game)
      @user.remove(@game)
    end
    assert Game.find_by(api_id: '7342970974890489')
    assert_not @user.games.find_by(api_id: @game.api_id)
  end

  test 'index shows correct game' do
    log_in_as(@user)
    get add_path
    post games_path,  game: { title: 'foo game', api_id: '7342970974890489' }
    post games_path,  game: { title: 'foo game2', api_id: '43224523525523' }
    @game1 = Game.find_by(title: 'foo game')
    @game2 = Game.find_by(title: 'foo game2')
    get game_path(id: @game2.id)
    assert_select 'h1', @game2.title.to_s
  end
end
