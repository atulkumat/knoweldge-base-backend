class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :upvotes, default: 0
      t.integer :downvotes, default: 0
      t.boolean :accepted, default: false 
      t.text :content, null: false 
      t.references :user, index: true, foreign_key: true, null: false 
      t.references :post, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
