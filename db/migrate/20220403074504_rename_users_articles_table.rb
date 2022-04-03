class RenameUsersArticlesTable < ActiveRecord::Migration[7.0]
  def change
    rename_table('users_articles', 'articles_users')
  end
end
