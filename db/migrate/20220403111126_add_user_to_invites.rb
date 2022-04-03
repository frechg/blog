class AddUserToInvites < ActiveRecord::Migration[7.0]
  def change
    change_table :invites do |t|
      t.belongs_to :user
    end
  end
end
