class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  has_secure_password

  validates :name, :email, presence: true

  validates :email, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }


  before_save :set_slug
  before_save :format_email
  before_save :format_name

  scope :by_name, -> { order(:name) }
  scope :not_admins, -> { by_name.where(admin: false || nil) }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = name.parameterize
  end

  def format_email
    self.email = email.downcase
  end

  def format_name
    self.name = name.downcase
  end

end
