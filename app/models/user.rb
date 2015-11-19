class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 },
    if: :validate_password?

  before_save :generate_slug

  private

  def validate_password?
    new_record? || password.present?
  end

  def generate_slug
    slug = self.username.gsub(/[^\w]|[\_]/, '-').downcase
    i = 1
    while !!User.find_by(slug: slug) do
      i == 1 ? slug += '-1' : slug = slug[0...-2] + "-#{i}"
    end
    self.slug = slug
  end
end
