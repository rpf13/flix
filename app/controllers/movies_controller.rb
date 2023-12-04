class MoviesController < ApplicationController
  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update(movie_params)
    redirect_to @movie
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.save
    redirect_to @movie
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, status: :see_other 
  end


end


private
# Private methods can't be called from outside of the class
# to follow DRY, method for hand over params is created and can
# be re-used in update, create, .. method

  def movie_params
    params.require(:movie).
      permit(:title, :description, :rating, :released_on, :total_gross)
  end