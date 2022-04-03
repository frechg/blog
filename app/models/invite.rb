class Invite < ApplicationRecord
  belongs_to :article
  belongs_to :user

  before_create :generate_token

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.article_id, Time.now, rand].join)
  end
end
