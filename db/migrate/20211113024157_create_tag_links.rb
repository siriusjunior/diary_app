class CreateTagLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_links do |t|
      t.references :user, null: false
      t.references :tag, null: false

      t.timestamps
    end

    add_index :tag_links, [:user_id, :tag_id], unique: true
  end
end
