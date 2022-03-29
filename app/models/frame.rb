class Frame < ApplicationRecord
  belongs_to :article
  has_many_attached :images, dependent: :destroy

  VALID_TYPES = ['image']

  validates :display_type, inclusion: { in: VALID_TYPES }
end
