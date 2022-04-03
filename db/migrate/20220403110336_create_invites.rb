class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :invites do |t|
      t.string :token
      t.belongs_to :article

      t.timestamps
    end
  end
end
