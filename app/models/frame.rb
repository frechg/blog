class Frame < ApplicationRecord
  belongs_to :article
  has_many_attached :images, dependent: :destroy do |attachable|
    attachable.variant :medium, resize_to_limit: [1200, nil]
  end

  validates :images, presence: true
  validate :image_type
  validate :image_size

  IMAGE_VALIDATIONS = {
    content_type: ['image/jpeg', 'image/png', 'image/heic', 'image/heif'],
    max_size: 10.megabytes
  }

  private

  def image_type
    images.each do |i|
      if !IMAGE_VALIDATIONS[:content_type].include?(i.content_type)
        errors.add(:images, 'must be jpeg, png, heic or heif format.')
        return
      end
    end
  end

  def image_size
    images.each do |i|
      if IMAGE_VALIDATIONS[:max_size] < i.byte_size
        errors.add(
          :images,
          "must be less than #{IMAGE_VALIDATIONS[:max_size].to_formatted_s(:human_size)}"
        )
        return
      end
    end
  end
end
