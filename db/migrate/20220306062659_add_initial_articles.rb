class AddInitialArticles < ActiveRecord::Migration[7.0]
  def up
    5.times do |i|
      Article.create(title: "Article #{i}", body: "An article", status: "public")
    end
  end

  def down
    Article.delete_all
  end
end
