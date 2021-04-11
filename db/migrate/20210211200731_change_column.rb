class ChangeColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :status, :integer, default: 0
    change_column :user_groups, :role, :integer, default: 2 
    remove_column :comments, :status
    add_column :comments, :accepted, :boolean, default: false
  end
end
