class RemoveIndexFromPostsCategories < ActiveRecord::Migration
  def change
    remove_index :post_categories, column: [:post_id, :category_id]
  end
end
