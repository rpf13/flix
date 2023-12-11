class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)

  # the dependent option destroy will make sure, child entries
  # (foreign_keys), which are reviews, will also be deleted if
  # the parent gets deleted
  has_many :reviews, dependent: :destroy

  validates :title, :released_on, :duration, presence: true

  validates :description, length: { minimum:25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  validates :rating, inclusion: { in: RATINGS }

  def self.released
    where("released_on < ?", Time.now).order("released_on desc")
  end

  def flop?
    # helper method flop? (returns true or false) to define
    # if a movie is a flop or not
    total_gross < 225000000 || total_gross.blank?
  end
end
