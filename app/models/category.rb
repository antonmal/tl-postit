class Category < ActiveRecord::Base
  include SluggableAnt

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  has_slug :name, on: :create
end
