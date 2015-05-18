class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
  	redirect_to sign_in_path unless current_user
  end

  def require_admin
    flash[:error] = "You do not have permission to do that." if !current_user.admin?
    redirect_to home_path unless current_user.admin?
  end

  def current_user
  	User.find(session[:user_id]) if session[:user_id]
  end

  def average_rating(reviewed_item)
    rating_total = 0
    review_count = reviewed_item.reviews.count
    reviewed_item.reviews.each do |review|
      rating_total += review.rating
    end
    rating_total/review_count if rating_total && review_count > 0
  end

  helper_method :current_user, :average_rating
end
