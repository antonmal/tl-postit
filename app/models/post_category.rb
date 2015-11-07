class PostCategory < ActiveRecord::Base
  self.primary_key = "index_post_categories_on_post_id_and_category_id"
  belongs_to :post
  belongs_to :category
end
