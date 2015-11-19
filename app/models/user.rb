class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 },
    if: :validate_password?

  before_save :generate_slug

  def to_param
    self.slug
  end

  def validate_password?
    new_record? || password.present?
  end

  def generate_slug
    slug = self.username.downcase
              .gsub(/\W|\_/, '-').gsub(/[\-]+/, '-')
              .gsub(/^[\-]+/, '').gsub(/[\-]+$/, '')
    i = 1
    while !!User.where.not(id: self.id).find_by(slug: slug) do
      i == 1 ? slug += '-1' : slug = slug.split('-')[0..-2].join('-') + "-#{i}"
      i += 1
    end
    self.slug = slug
  end
end
