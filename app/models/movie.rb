class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)

  before_save :set_slug
  # before we save the object to the db, we need to run the
  # private set_slug method, in order to transform the url to
  # our user friendly url and create the slug field of the db entry
  # the set_slug is actually a callback method.



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

  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_one_attached :main_image
  # ActiveStorage attachment association

  validates :title, presence: true, uniqueness: true

  validates :released_on, :duration, presence: true

  validates :description, length: { minimum:25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validate :acceptable_image
  # refers to private method in this file. Note that it is singular
  # validate and not validates, since plural needs 

  # Validation was used when working with local image files during development
  # This got changed to ActiveStorage and hence no longer needed
  # validates :image_file_name, format: {
  #   with: /\w+\.(jpg|png)\z/i,
  #   message: "must be a JPG or PNG image"
  # }

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

  def to_param
    # override the default to_param model, which is called when a
    # model object needs to be converted into a URL parameter
    # All models that subclass ApplicationRecord inherit a default
    # to_param method that simply returns the id of the record as a string
    slug
  end

private

  def set_slug
    # create the slug field from title, use parametrize to convert
    # string. self is required in order to not only create a local variable
    # but assign it to the instance.
    self.slug = title.parameterize
  end

  def acceptable_image
    # custom validation of acceptabel image used for movies
    return unless main_image.attached?

    unless main_image.blob.byte_size <= 1.megabyte
      errors.add(:main_image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(main_image.blob.content_type)
      errors.add(:main_image, "must be a JPEG or PNG")
    end
  end
end