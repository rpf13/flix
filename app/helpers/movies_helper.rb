module MoviesHelper

  def total_gross(movie)
    # used in movies index view
    if movie.flop?
      # calls the custom flop? method out of movie model
      "Flop!"
    else
    number_to_currency(movie.total_gross, precision: 0)
    end
  end

  def year_of(movie)
    # used to display the year of its release
    movie.released_on.year
  end
end
