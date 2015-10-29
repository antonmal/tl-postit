class CreateCategory < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
    end

    create_table :categories_posts, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :post, index: true
    end
  end
end
