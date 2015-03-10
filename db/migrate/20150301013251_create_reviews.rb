class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :star_count
      t.text :review
      t.integer :user_id
    end
  end
end
