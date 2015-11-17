class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 },
    if: :validate_password?

  private

  def validate_password?
    new_record? || password.present?
  end
end
