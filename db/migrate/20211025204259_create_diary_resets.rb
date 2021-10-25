class CreateDiaryResets < ActiveRecord::Migration[5.2]
  def change
    create_table :diary_resets do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
