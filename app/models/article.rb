class Article < ApplicationRecord
  include Visible

  has_and_belongs_to_many :users
  has_many :frames, dependent: :destroy
  has_many :invites, dependent: :destroy

  accepts_nested_attributes_for :frames, allow_destroy: true

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates_associated :frames

  def list_authors
    author_count = self.users.count
    list = "Author".pluralize(author_count) + ": "

    self.users.each_with_index do |u, i|
       if i == 0
        list << u.user_name
      elsif i < author_count - 1
        list << ", " + u.user_name
      else
        list << " and " + u.user_name
      end
    end

    return list
  end

  def sort_frames
    # Sorts story frames by image create date

    # Iterate through each frame in the story
    # Get created_at_date using mini_magick or exiftool
  end
end
