class AddNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_name, :string
    add_index :users, :user_name, name: 'index_users_on_user_name'
  end
end
