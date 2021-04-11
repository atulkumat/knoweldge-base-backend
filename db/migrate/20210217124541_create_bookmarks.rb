class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t| 
      t.string :note 
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.index [:user_id, :post_id], unique: true 
      t.timestamps
    end
  end
end
