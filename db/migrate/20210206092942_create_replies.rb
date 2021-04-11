class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.text :content, null: false 
      t.references :user, index: true, foreign_key: true, null: false
      t.references :comment, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
