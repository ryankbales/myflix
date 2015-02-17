require 'spec_helper'

describe Video do
	it "saves itself" do
		video = Video.new(title: 'Dances With Wolves', description: 'Best movie ever!')
		video.save
		expect(Video.first).to eq(video)
	end
end