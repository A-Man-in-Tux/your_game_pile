class GamesController < ApplicationController
 before_action :logged_in_user
 
 def index
   @user = current_user
   @searched_games = []
   if params[:search]
    @games = @user.games.search(params[:search])
   else
    @games = @user.games.all
    @game = Game.new
   end
 end
 
 def new
  @game = Game.new
  if params[:search]
   @searched_games = Game.giantbomb_search(params[:search])
   respond_to do |format|
    format.js
   end
  else
   @searched_games = []
  end
 end
  
 def create
  if Game.find_by(game_params)
   @game = Game.find_by(game_params)
   current_user.add(@game)
  else
   @game = Game.create(game_params)
   @new_game = Game.find_by(game_params)
   if @new_game.image_url != nil
     @new_game.image_from_url(@new_game.image_url)
     @new_game.save
   end
   @user = current_user
   @user.add(@game)
  end
   @games = @user.games.all
   @searched_games = []
   respond_to do |format|
    format.html { render :index }
    format.js 
   end
 end
 
 def show
  @user = current_user
  @game = @user.games.find(params[:id])
 end
 
 def sort
  @user = current_user
  @searched_games = []
  if params[:filter]
   @games = @user.games.all
   @games = Game.filter(params[:filter],@games)
   respond_to do |format|
    format.js 
    format.html {render :index}
   end
  end
 end
 
def remove_game
 @user = current_user
 @game = Game.find_by(params[:id])
 @user.remove(@game)
 redirect_to games_path
end
 
 private
 
 def logged_in_user
   unless logged_in?
     flash[:danger] = "Please sign in"
     redirect_to login_url
   end
 end
 
 def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless @user == current_user
 end
  
 def game_params
  params.require(:game).permit(:title, :api_id, :api_url, :image_url, :api_data, :image, :filter, :platforms)
 end
  
end
