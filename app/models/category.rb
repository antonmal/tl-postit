class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true

  before_save :generate_slug, on: create

  def to_param
    self.slug
  end

  def generate_slug
    slug = self.name.downcase
              .gsub(/\W|\_/, '-').gsub(/[\-]+/, '-')
              .gsub(/^[\-]+/, '').gsub(/[\-]+$/, '')
    i = 1
    while !!Category.where.not(id: self.id).find_by(slug: slug) do
      i == 1 ? slug += '-1' : slug = slug[0...-2] + "-#{i}"
      i += 1
    end
    self.slug = slug
  end
end
