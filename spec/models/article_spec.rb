require 'rails_helper'

RSpec.describe Article, type: :model do
  it "should not save article without title" do
    article = Article.new(title: "", body: "Article body.", status: "public")
    expect(article.save).to be(false)
  end

  it "should not save article without a status" do
    article = Article.new(title: "Title", body: "Article body.")
    expect(article.save).to be(false)
  end

  it "should not save article without a short body" do
    article = Article.new(title: "Title", body: "body", status: "public")
    expect(article.save).to be(false)
  end
end
