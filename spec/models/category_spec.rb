require 'spec_helper'

describe Category do
	it "saves itself" do
		category = Category.new(name: "Test Category")
		category.save
		expect(Category.first).to eq(category)
	end

	it "has many videos" do
		category = Category.create(name: "Category")
		video_1 = Video.create(title: "Video One", description: "This is video one.", category_id: category.id)
		video_2 = Video.create(title: "Video two", description: "This is video two.", category_id: category.id)

		expect(category.videos).to eq([video_1, video_2])
	end
end