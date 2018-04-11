class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :replies_count, :integer, default: 0

    change_column :posts, :replies_count, :integer, default: 0
    change_column :posts, :viewed_count, :integer, default: 0

    rename_column :posts, :viewed_count, :views_count
  end
end
