class User < ApplicationRecord
  include Clearance::User

  has_and_belongs_to_many :articles

  validates :user_name, presence: true
  validates :user_name, uniqueness: true
end
