class User < ApplicationRecord
  include Clearance::User

  validates :user_name, presence: true
  validates :user_name, uniqueness: true
end
