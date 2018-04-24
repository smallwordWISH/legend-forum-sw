class RemoveCategoryIdFromPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :category_id, :integer
  end
end
