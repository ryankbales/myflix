class ChangeColumnNameInReviews < ActiveRecord::Migration
  def change
    rename_column :reviews, :star_count, :rating
  end
end
