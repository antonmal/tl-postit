class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true

  before_save :generate_slug

  private

  def generate_slug
    slug = self.name.gsub(/[^\w]|[\_]/, '-').downcase
    i = 1
    while !!Category.find_by(slug: slug) do
      i == 1 ? slug += '-1' : slug = slug[0...-2] + "-#{i}"
    end
    self.slug = slug
  end
end
