class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)

  # the dependent option destroy will make sure, child entries
  # (foreign_keys), which are reviews, will also be deleted if
  # the parent gets deleted
  has_many :reviews, dependent: :destroy

  has_many :favorites, dependent: :destroy
  # the model it refers to is favorite but the table is favorites
  # therefore we have to create the association with the table, so
  # by convention this is plural.

  has_many :fans, through: :favorites, source: :user
  # The through option takes the name of the association through
  # which to perform the query, which is favorites in this case. 
  # It must be declared after the has_many :favorites association. 
  # Since Rails can't infer that a fan is actually a user, 
  # you also need to use the source option to specify that the source
  # is :user. Rails then knows to use the belongs_to :user association 
  # in the Favorite model to query the users.

  has_many :critics, through: :reviews, source: :user
  # not implemented yet in any view

  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :title, :released_on, :duration, presence: true

  validates :description, length: { minimum:25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  validates :rating, inclusion: { in: RATINGS }

  # custom "scope" queries
  scope :released, -> { where("released_on < ?", Time.now).order("released_on desc") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, ->(max=5) { released.limit(max) }
  scope :hits, -> { released.where("total_gross >= 300000000").order(total_gross: :desc) }
  scope :flops, -> { released.where("total_gross < 225000000").order(total_gross: :asc) }

  # below the "legacy" way to execute a custom query via class level method
  # which got replaced be scope and lambda
  # def self.released
  #   where("released_on < ?", Time.now).order("released_on desc")
  # end

  def flop?
    # helper method flop? (returns true or false) to define
    # if a movie is a flop or not
    unless (reviews.count > 50 && average_stars >= 4)
      total_gross < 225000000 || total_gross.blank?
    end
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100
  end
end
