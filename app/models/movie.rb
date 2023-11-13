class Movie < ApplicationRecord
  def flop?
    # helper method flop? (returns true or false) to define
    # if a movie is a flop or not
    total_gross < 225000000 || total_gross.blank?
  end
end
