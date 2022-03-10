require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /index" do
    it "it lists the public articles" do
      article = create(:article)
      get articles_url

      expect(response).to have_http_status(200)
      expect(response.body).to include(article.title)
    end
  end

  describe "GET /article/:id" do
    it "shows a specific article" do
      article = create(:article)

      get article_url(article)

      expect(response).to have_http_status(200)
      expect(response.body).to include(article.body)
    end
  end

  describe "POST /article" do
    it "creates a new article" do
      get "/articles/new"

      post "/articles", params: {
        article: {
          title: "Article 1",
          body: "Body content.",
          status: "public"
        }
      }

      expect(response).to have_http_status(302)
      expect(Article.count).to eq(1)
    end
  end

  describe "DELETE /article/:id" do
    it "destroys the article" do
      article = create(:article)

      delete "/articles/#{article.id}"

      expect(response).to have_http_status(303)
      expect(Article.count).to eq(0)
    end
  end
end
