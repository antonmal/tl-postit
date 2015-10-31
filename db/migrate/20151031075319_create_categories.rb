class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :post_categories, id: false do |t|
      t.integer :post_id
      t.integer :category_id
    end
  end
end
