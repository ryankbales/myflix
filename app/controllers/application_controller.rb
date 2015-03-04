class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
  	redirect_to sign_in_path unless current_user
  end

  def current_user
  	User.find(session[:user_id]) if session[:user_id]
  end

  def average_rating(obj)
    rating_total = 0
    review_count = obj.reviews.count
    obj.reviews.each do |review|
      rating_total += review.rating
    end
    rating_total/review_count if rating_total && review_count > 0
  end

  helper_method :current_user, :average_rating
end
