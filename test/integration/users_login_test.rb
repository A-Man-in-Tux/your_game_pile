require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
  end

  test 'invalid login' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: '', password: '' }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'valid login' do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/_user_home'
    assert is_logged_in?
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    # make sure no login link on homepage
    get root_path
    assert_template 'static_pages/_user_home'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path

    # test logout
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', logout_path,      count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end
end
