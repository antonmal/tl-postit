class Post < ActiveRecord::Base
  include Voteable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true, uniqueness: true

  before_save :generate_slug!, on: :create

  def to_param
    self.slug
  end

  def generate_slug!
    slug = self.title.downcase
              .gsub(/\W|\_/, '-').gsub(/[\-]+/, '-')
              .gsub(/^[\-]+/, '').gsub(/[\-]+$/, '')
    i = 1
    while !!Post.where.not(id: self.id).find_by(slug: slug) do
      i == 1 ? slug += '-1' : slug = slug.split('-')[0..-2].join('-') + "-#{i}"
      i += 1
    end
    self.slug = slug
  end
end
