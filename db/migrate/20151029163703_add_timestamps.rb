class AddTimestamps < ActiveRecord::Migration
  def change

    change_table :users do |t|
      t.timestamps
      User.find_each do |e|
        e.created_at, e.updated_at = Time.now
        e.save!
      end
    end

    change_table :posts do |t|
      t.timestamps
      Post.find_each do |e|
        e.created_at, e.updated_at = Time.now
        e.save!
      end
    end

    change_table :comments do |t|
      t.timestamps
      Comment.find_each do |e|
        e.created_at, e.updated_at = Time.now
        e.save!
      end
    end

    change_table :categories do |t|
      t.timestamps
      Category.find_each do |e|
        e.created_at, e.updated_at = Time.now
        e.save!
      end
    end
    
  end
end
