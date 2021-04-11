class CreateCommentVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :comment_votes do |t|
      t.integer :status, null: false 
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.index [:user_id, :comment_id], unique: true
      t.timestamps
    end
  end
end
