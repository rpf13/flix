class ReviewsController < ApplicationController

  before_action :set_movie
  # We always want to run the set_movie method before
  # running any action's code - we want to have the movie
  # object

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    # review_params comes from private method
    @review = @movie.reviews.new(review_params)

    if @review.save
      redirect_to movie_reviews_path(@movie),
      notice: "Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end

private

# The create action must send a list of attributes, define
# which arae valid
def review_params
  params.require(:review).permit(:name, :comment, :stars)
end

def set_movie
  @movie = Movie.find(params[:movie_id])
end