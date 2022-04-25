class AddUserToFrames < ActiveRecord::Migration[7.0]
  def change
    add_reference :frames, :user, foreign_key: true
  end
end
