class AddDiaryDateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :diary_date, :integer, null: false, default: 1
  end
end
