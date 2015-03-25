require 'spec_helper'

describe Category do

	it { should have_many(:videos)}

	categories = Category.create([{name: 'Western'}, {name: 'Comedy'}, {name: 'Drama'}, {name: 'Cult'}])

	describe "#recent_videos" do

		it "returns the array of videos in reverse chronical order" do
			category = Category.create(name: "category")
			movie_one = Video.create(title: "Movie One", description: "This is movie one", category_id: category.id, created_at: 1.day.ago)
			movie_two = Video.create(title: "Movie Two", description: "This is movie two", category_id: category.id)
			expect(category.recent_videos).to eq([movie_two, movie_one])
		end

		it "returns all videos if there are 6 or less recent videos" do
			category = Category.create(name: "category")
			movie_one = Video.create(title: "Movie One", description: "This is movie one", category_id: category.id, created_at: 1.day.ago)
			movie_two = Video.create(title: "Movie Two", description: "This is movie two", category_id: category.id)
			expect(category.recent_videos.count).to eq(2)
		end
		
		it "returns only six videos if there are more than 6 recent videos" do
			category = Category.create(name: "category")
			7.times {Video.create(title: "Movie Two", description: "This is movie two", category_id: category.id)}
			expect(category.recent_videos.count).to eq(6)
		end

		it "returns the 6 most recent videos" do
			category = Category.create(name: "category")
			6.times {Video.create(title: "Movie Two", description: "This is movie two", category_id: category.id)}
			movie_one = Video.create(title: "Movie One", description: "This is movie one", category_id: category.id, created_at: 1.day.ago)
			expect(category.recent_videos).not_to include(movie_one)
		end

		it "returns an empty array if there are no videos for the category" do
			category = Category.create(name: "category")
			expect(category.recent_videos).to eq([])
		end
		
	end
end