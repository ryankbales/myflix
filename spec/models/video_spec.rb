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
end