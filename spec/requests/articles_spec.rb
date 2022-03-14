require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    it "lists the 5 latest public articles" do
      6.times do |i|
        create(:article)
      end

      get "/articles"

      expect(response).to have_http_status(200)
      expect(response.body).to include("Article 6")
      expect(response.body).not_to include("Article 1")
    end
  end

  describe "GET /article/:id" do
    it "shows a public article" do
      article = create(:article)

      get "/articles/#{article.id}"

      expect(response).to have_http_status(200)
      expect(response.body).to include(article.body)
    end
  end

  describe "POST /article" do
    it "creates a new article and redirects to it" do
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

  describe "Article update" do
    scenario "the author makes a valid update" do
      article = create(:article)

      get "/articles/#{article.id}/edit"

      expect(response).to have_http_status(200)

      patch "/articles/#{article.id}", params: {
        article: { title: "Updated title" }
      }

      expect(response).to have_http_status(302)
      expect(article.reload.title).to eq("Updated title")
    end

    scenario "the author makes an invalid update" do
      article = create(:article, title: "Original title")

      patch "/articles/#{article.id}", params: {
        article: { title: "" }
      }

      expect(response).to have_http_status(422)
      expect(article.reload.title).to eq("Original title")
    end
  end

  describe "DELETE /article/:id" do
    it "destroys the article and redirects to the root_path" do
      article = create(:article)

      delete "/articles/#{article.id}"

      expect(response).to have_http_status(303)
      expect(Article.count).to eq(0)
    end
  end
end
