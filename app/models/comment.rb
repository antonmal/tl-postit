class Comment < ActiveRecord::Base
  include VoteableAnt

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post

  validates :body, presence: true, length: { minimum: 5 }

  scope :sorted_by_votes, -> {
    joins("LEFT OUTER JOIN votes ON votes.voteable_id = comments.id AND votes.voteable_type = 'Comment'")
    .select("comments.*, SUM(CASE votes.vote WHEN 't' THEN 1 WHEN 'f' THEN -1 ELSE 0 END) AS TotalVotes")
    .group("comments.id")
    .order("TotalVotes DESC", "comments.updated_at DESC")
  }
end
