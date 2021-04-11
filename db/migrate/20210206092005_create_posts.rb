class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :visibility, default: 0 
      t.integer :upvotes, default: 0
      t.integer :downvotes, default: 0
      t.references :user, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
