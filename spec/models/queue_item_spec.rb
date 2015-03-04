require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe '#video_title' do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'Video')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('Video')
    end
  end

  describe '#rating' do
    it "returns the rating of the review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user_id: user.id, video_id: video.id, rating: 3)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if the rating of the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe '#category_name' do
    it "returns the category's name of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category_id: category.id)
      queue_item = Fabricate(:queue_item, video_id: video.id)
      expect(queue_item.category_name).to eq(category.name) 
    end
  end

  describe "#category" do
    it "returns the category of the view" do
      category = Fabricate(:category)
      video = Fabricate(:video, category_id: category.id)
      queue_item = Fabricate(:queue_item, video_id: video.id)
      expect(queue_item.category).to eq(category) 
    end
  end
end