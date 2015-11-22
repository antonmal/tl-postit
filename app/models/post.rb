class Post < ActiveRecord::Base
  include VoteableAnt
  include SluggableAnt

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true, uniqueness: true

  has_slug :title, on: :create

  default_scope { sorted_by_votes_and_update_at }

  scope :sorted_by_votes_and_update_at, -> {
    joins("LEFT OUTER JOIN votes ON votes.voteable_id = posts.id AND votes.voteable_type = 'Post'")
    .select("posts.*, SUM(CASE votes.vote WHEN 't' THEN 1 WHEN 'f' THEN -1 ELSE 0 END) AS TotalVotes")
    .group("posts.id")
    .order("TotalVotes DESC", "posts.updated_at DESC")
  }
end
