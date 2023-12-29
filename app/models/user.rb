class User < ApplicationRecord

  has_many :reviews, dependent: :destroy
  # has_many association with reviews 

  has_many :favorites, dependent: :destroy

  validates :name, presence: true

  validates :username, presence: true,
                     format: { with: /\A[A-Z0-9]+\z/i },
                     uniqueness: { case_sensitive: false }

  validates :email, presence: true,
            format: { with: /\S+@\S+/ },
            uniqueness: { case_sensitive: false }

  # setting the allow_blank option to true, the length validation 
  # won't run if the password field is blank. That's important because
  # a password isn't required when a user updates his name and/or email
  validates :password, length: { minimum: 6, allow_blank: true }

  has_secure_password

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end
end
