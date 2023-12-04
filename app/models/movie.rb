class Movie < ApplicationRecord

  def self.released
    where("released_on < ?", Time.now).order("released_on desc")
  end

  def flop?
    # helper method flop? (returns true or false) to define
    # if a movie is a flop or not
    total_gross < 225000000 || total_gross.blank?
  end
end
