require 'rails_helper'

RSpec.describe Article, type: :model do
  it "should not save article without title" do
    article = Article.new
    expect(article.save).to be(false)
  end
end
