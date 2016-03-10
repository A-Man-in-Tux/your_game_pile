class LibrarysController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: :destroy
  def create
    game = Game.find(params[:id])
    current_user.add(game)
    redirect_to games_path
  end
  
  def destroy
   #game = Game.find(params[:id])
    @library.destroy
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
      @library = current_user.librarys.find_by(id: params[:id])
      redirect_to root_url if @library.nil?
    end
    
    
end
