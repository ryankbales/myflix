require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('position asc') }
  it { should have_many(:following_relationships) }

  it "generates a random token when the user is created" do
    laura = Fabricate(:user)
    expect(laura.token).to be_present
  end

  describe "#queued_video?" do
    it "returns true when the queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_truthy
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_falsey
    end
  end

  describe "#follows?" do
    it "returns true if the user is already following the leader" do
      follower = Fabricate(:user)
      leader = Fabricate(:user)
      Fabricate(:relationship, leader_id: leader.id, follower_id: follower.id)
      follower.follows?(leader).should be_truthy
    end

    it "returns false if the user does not follow the leader" do
      follower = Fabricate(:user)
      leader = Fabricate(:user)
      follower.follows?(leader).should be_falsey
    end
  end

  describe "#follow" do
    it "follows another user" do
      laura = Fabricate(:user)
      ryan = Fabricate(:user)
      laura.follow(ryan)
      expect(laura.follows?(ryan)).to be_truthy
    end

    it "does not follow one self" do
      laura = Fabricate(:user)
      laura.follow(laura)
      expect(laura.follows?(laura)).to be_falsey
    end
  end

  describe "#can_follow?" do
    it "returns true if the current user can follow another user" do
      follower = Fabricate(:user)
      leader = Fabricate(:user)
      follower.can_follow?(leader).should be_truthy
    end

    it "returns false if the current_user cannot follow another user" do
      follower = Fabricate(:user)
      leader = Fabricate(:user)
      Fabricate(:relationship, leader_id: leader.id, follower_id: follower.id)
      follower.can_follow?(leader).should be_falsey
    end
  end

  describe "deactivate!" do
    it "deactivates an active user" do
      oscar = Fabricate(:user, active: true)
      oscar.deactivate!
      expect(oscar).not_to be_active
    end
  end
  
end