class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :description   
      t.string :name, null: false, unique: true 
      t.index :name, unique: true
      t.timestamps
    end
  end
end
