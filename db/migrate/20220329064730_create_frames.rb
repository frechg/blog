class CreateFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :frames do |t|
      t.string :display_type
      t.text :caption
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
