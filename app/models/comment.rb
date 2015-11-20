class Comment < ActiveRecord::Base
  include VoteableAnt

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post

  validates :body, presence: true, length: { minimum: 5 }
end
