class CreateDiaries < ActiveRecord::Migration[5.2]
  def change
    create_table :diaries do |t|
      t.text :body, null: false
      t.text :check
      t.string :image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
