class User < ApplicationRecord
  include Clearance::User

  has_and_belongs_to_many :articles
  has_many :frames

  validates :user_name, presence: true
  validates :user_name, uniqueness: true

  def is_author?(article)
    if article.users.include?(self)
      return true
    else
      return false
    end
  end
end
