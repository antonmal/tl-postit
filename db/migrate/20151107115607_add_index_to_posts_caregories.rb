class AddIndexToPostsCaregories < ActiveRecord::Migration
  def change
    add_index :post_categories, [:post_id, :category_id], unique: true
  end
end
