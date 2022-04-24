class RenameArticleBodyToArticleSummary < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :body, :summary
  end
end
