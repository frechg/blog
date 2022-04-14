class RemoveDisplayTypeFromFrames < ActiveRecord::Migration[7.0]
  def change
    remove_column :frames, :display_type
  end
end
