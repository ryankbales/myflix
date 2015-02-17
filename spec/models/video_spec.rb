require 'spec_helper'

describe Video do
	it "saves itself" do
		video = Video.new(title: 'Dances With Wolves', description: 'Best movie ever!')
		video.save
		expect(Video.first).to eq(video)
	end

	it "belongs to a category" do
		category = Category.create(name: "Western")
		video = Video.create(title: 'Dances With Wolves', description: 'Best movie ever!', category_id: category.id)
		expect(Video.first.category).to eq(category)
	end

	it "should be valid with title and description" do
		video =  Video.new(title: 'Dances With Wolves', description: 'Best movie ever!')
		video.should be_valid
	end

	it "should not be valid without a title" do
		video =  Video.new(description: 'Best movie ever!')
		video.should_not be_valid
	end

	it "should not be valid without a description" do
		video =  Video.new(title: 'Dances With Wolves')
		video.should_not be_valid
	end
end