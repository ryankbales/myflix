require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }

	describe "#search_by_title" do
		it "returns an empty array if there is no match" do
			dances_with = Video.create(title: "Dances With Wolves", description: "You are my brother, and I will not forget you!")
			donnie_darko = Video.create(title: "Donnie Darko", description: "A dark, dark, creative film.")
			expect(Video.search_by_title("Kickass")).to eq([])
		end

		it "returns an array of one video for an exact match" do
			dances_with = Video.create(title: "Dances With Wolves", description: "You are my brother, and I will not forget you!")
			donnie_darko = Video.create(title: "Donnie Darko", description: "A dark, dark, creative film.")
			expect(Video.search_by_title("Dances With Wolves")).to eq([dances_with])
		end

		it "returns an array of one video for a partial match" do
			dances_with = Video.create(title: "Dances With Wolves", description: "You are my brother, and I will not forget you!")
			donnie_darko = Video.create(title: "Donnie Darko", description: "A dark, dark, creative film.")
			expect(Video.search_by_title("Dances")).to eq([dances_with])
		end

		it "returns an array of all matches ordered by created_at" do
			dances_with = Video.create(title: "Dances With Wolves", description: "You are my brother, and I will not forget you!", created_at: 1.day.ago)
			donnie_darko = Video.create(title: "Donnie Darko", description: "A dark, dark, creative film.")
			expect(Video.search_by_title("D")).to eq([donnie_darko, dances_with])
		end
		
		it "returns an empty array for a search with an empty string" do
			dances_with = Video.create(title: "Dances With Wolves", description: "You are my brother, and I will not forget you!", created_at: 1.day.ago)
			donnie_darko = Video.create(title: "Donnie Darko", description: "A dark, dark, creative film.")
			expect(Video.search_by_title("")).to eq([])
		end
	end
end