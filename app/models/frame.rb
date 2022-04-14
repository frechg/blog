class Frame < ApplicationRecord
  belongs_to :article
  has_many_attached :images, dependent: :destroy

  validates :images, presence: true
end
