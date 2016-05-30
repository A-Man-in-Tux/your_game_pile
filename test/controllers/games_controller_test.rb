require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  def setup
    @user = users(:foo)
    @other_user = users(:foo2)
  end

  test 'should get new' do
    log_in_as(@user)
    get :new
    assert_response :success
  end

  test 'should redirect new when not logged in' do
    get :new, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
