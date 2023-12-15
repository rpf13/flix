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

  # no longer used, would display text on how many
  # stars in average
  def average_stars(movie)
    if movie.average_stars.zero?
      content_tag(:strong, "No reviews")
    else
      "*" * movie.average_stars.round
    end

  end
end
