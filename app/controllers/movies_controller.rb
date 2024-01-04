class MoviesController < ApplicationController

  before_action :require_signin, except: [:index, :show]

  before_action :require_admin, except: [:index, :show]
  # both before_action are defined in application controller

  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    case params[:filter]
    when "upcoming"
      @movies = Movie.upcoming
    when "recent"
      @movies = Movie.recent
    when "hits"
      @movies = Movie.hits
    when "flops"
      @movies = Movie.flops
    else
      @movies = Movie.released
    end
  end

  def show
    # @movie = Movie.find(params[:id])
    # used before slug was introduced
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    if current_user
    @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
    # @movie = Movie.find(params[:id])
    # used before slug was introduced
  end

  def update
    # @movie = Movie.find(params[:id])
    # used before slug was introduced
    if 
      @movie.update(movie_params)
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if 
      @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # @movie = Movie.find(params[:id])
    # used before slug was introduced
    @movie.destroy
    redirect_to movies_url, status: :see_other,
      alert: "Movie successfully deleted!"
  end


private
# Private methods can't be called from outside of the class
# to follow DRY, method for hand over params is created and can
# be re-used in update, create, .. method

  def movie_params
    # since the genre_ids is an array, we also need to define it as such
    params.require(:movie).
      permit(:title, :description, :rating, :released_on, :total_gross,
              :director, :duration, :image_file_name, genre_ids: [])
  end

  def set_movie
    # private method to find the movie by slug, which is called
    # in a before action, so it is available to all methods
    @movie = Movie.find_by!(slug: params[:id])
  end
end