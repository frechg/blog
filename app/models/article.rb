class Article < ApplicationRecord
  include Visible

  belongs_to :user
  has_many :frames, dependent: :destroy

  accepts_nested_attributes_for :frames, allow_destroy: true

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates_associated :frames
end
