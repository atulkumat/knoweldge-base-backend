class CreatePostGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :post_groups do |t|
      t.boolean :shared, default: false
      t.references :post, null: false, foreign_key: true
      t.references :group, foreign_key: true, null: false
      t.timestamps
    end
  end
end
