class AddCommentAuthorizationToDiaries < ActiveRecord::Migration[5.2]
  def change
    add_column :diaries, :comment_authorization, :boolean, default: true, null: false
  end
end
