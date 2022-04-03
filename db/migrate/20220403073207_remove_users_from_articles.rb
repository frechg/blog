class RemoveUsersFromArticles < ActiveRecord::Migration[7.0]
  def change
    change_table :articles do |t|
      t.remove_references :user
    end
  end
end
