class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have created a new video."
      redirect_to new_admin_video_path
    else
      flash[:error] = "You forgot to enter some required video info."
      render :new
    end
  end

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover)
  end
end