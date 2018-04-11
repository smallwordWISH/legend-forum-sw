class ChangeColumnToPosts < ActiveRecord::Migration[5.1]
  def change
    change_column :posts, :draft, :boolean, default: false
  end
end
