require 'spec_helper'

describe User do
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:full_name)}
  it {should validate_uniqueness_of(:email)}

  it {should have_many(:reviews).order('created_at DESC')}
  it {should have_many(:queue_items).order('position asc')}
  it {should have_many(:following_relationships)}

  describe "#queued_video?" do

    it "returns true when the queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_true
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_false
    end
  end
  
end