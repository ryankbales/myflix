class VideosController < ApplicationController
	before_filter :require_user
	def index
		@videos = Video.search_by_title(params[:search])
		@categories = Category.all
	end

	def new
	end

	def create
	end

	def show
		@video = Video.find(params[:id])
		@review = Review.new
	end

	def edit
	end

	def update
	end

	def destroy
	end
	
end