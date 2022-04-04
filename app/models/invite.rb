class Invite < ApplicationRecord
  belongs_to :article
  belongs_to :user

  before_create :generate_token

  INVITE_VALID_PERIOD = 1.day

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.article_id, Time.now, rand].join)
  end

  def accept(user)
    user.articles << self.article
  end

  def expired?
    self.created_at + INVITE_VALID_PERIOD < Time.now
  end
end
