class VideosController < ApplicationController

	def index
		@videos = Video.all
		@categories = Category.all
	end

	def new
	end

	def create
	end

	def show
		@video = Video.find(params[:id])
	end

	def edit
	end

	def update
	end

	def destroy
	end
	
end