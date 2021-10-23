class CreateDiaryDateCounters < ActiveRecord::Migration[5.2]
  def change
    create_table :diary_date_counters do |t|
      t.references :diary, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
