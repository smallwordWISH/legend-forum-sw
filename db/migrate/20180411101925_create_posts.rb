class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.string :picture
      t.string :authority
      t.boolean :draft
      t.integer :replies_count
      t.integer :viewed_count

      t.timestamps
    end
  end
end
