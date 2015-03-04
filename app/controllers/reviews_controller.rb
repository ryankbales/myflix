class ReviewsController < ApplicationController

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(params.require(:review).permit(:rating, :review))
    @review.user = current_user
    if @review.save
      flash[:notice] = "Your review has been posted."
    else
      flash[:errors] = "You need to enter both a rating and review."
    end
    redirect_to video_path(@video)
  end

  def edit
    @review = Review.find(params[:id])
    @video = @review.video
  end

  def update
    @review = Review.find(params[:id])
    @video = @review.video
    if @review.update(params.require(:review).permit(:rating, :review))
      flash[:notice] = "Your review has been updated."
      redirect_to video_path(@video)
    else
      flash[:errors] = "You either didn't give the video a rating or a review."
    end
    
  end
end