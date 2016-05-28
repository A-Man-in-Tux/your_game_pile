class StaticPagesController < ApplicationController
  def home
     @user = User.new
     if logged_in?
       @user = current_user
       @games = @user.games.take(3)
     end
  end

  def about
  end

end
