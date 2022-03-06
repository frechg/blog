class RemoveInitialArticles < ActiveRecord::Migration[7.0]
  def up
    Article.delete_all
  end

  def down
    3.times do |i|
      Article.create(title: "Article #{i}", body: "An article.", status: "public")
    end
  end
end
