class FavoritesController < ApplicationController
  
  before_action :set_movie
  before_action :require_signin
  

  def create
    # @movie = Movie.find(params[:movie_id])
    # no longer required since before action create
    # the @movie object
    @movie.favorites.create!(user: current_user)

    redirect_to @movie
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy

    # @movie = Movie.find(params[:movie_id])
    # no longer required since before action create
    # the @movie object
    redirect_to @movie
  end
end

private

def set_movie
  @movie = Movie.find(params[:movie_id])
end
