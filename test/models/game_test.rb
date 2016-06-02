require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = games(:foo_game)
    @api_key = ENV['FB_APP_ID']
  end

  test 'should be valid' do
    assert @game.valid?
  end

  test 'api_id should be present' do
    @game.api_id = ' '
    assert_not @game.valid?
  end

  test 'api_id should be unique' do
    duplicate_game = @game.dup
    @game.save
    assert_not duplicate_game.valid?
  end

  test 'giantbomb_search should return parsed json' do
    VCR.use_cassette('giantbomb_api_response') do
      @data = Game.giantbomb_search('megaman')
      assert_not @data == nil
      assert_not @data[1][:title] == nil
      assert @data[1][:title] == "Mega Man 9"
    end
  end
end
