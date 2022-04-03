class CreateUsersArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :users_articles, id: false do |t|
      t.belongs_to :user
      t.belongs_to :article
    end
  end
end
