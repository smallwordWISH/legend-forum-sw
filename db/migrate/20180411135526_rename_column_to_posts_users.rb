class RenameColumnToPostsUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :posts, :name, :title
    rename_column :users, :title, :name
  end
end
