class CreatePostVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :post_votes do |t|
      t.integer :status, null: false 
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.index [:user_id, :post_id], unique: true
      t.timestamps
    end
  end
end
