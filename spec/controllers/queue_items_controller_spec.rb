require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "sets @queue_items to the queued items of the logged in user" do
      ryan = Fabricate(:user)
      session[:user_id] = ryan.id
      item_1 = Fabricate(:queue_item, user: ryan)
      item_2 = Fabricate(:queue_item, user: ryan)
      get :index
      expect(assigns(:queue_items)).to match_array([item_1, item_2])
    end
    it "redirects to sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST index" do
    context "when a user adds a video to the queue" do
      let(:video) { Fabricate(:video) }
      it "redirects to the my queue page" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
      it "creates a queue item" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "creates the queue item that is associated with the video" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates the queue item that is associated with the user" do
        ryan = Fabricate(:user)
        session[:user_id] = ryan.id
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(ryan)
      end
    end
    context "when a queue item is created and there is more than one" do
      let(:video) { Fabricate(:video) }
      let(:next_video) { Fabricate(:video) }
      it "puts the video as the last video in the queue" do
        ryan = Fabricate(:user)
        session[:user_id] = ryan.id
        Fabricate(:queue_item, video_id: video.id, user: ryan)
        post :create, video_id: next_video.id
        next_video_queue_item = QueueItem.where(video_id: next_video.id, user_id: ryan.id).first
        expect(next_video_queue_item.position).to eq(2)
      end
    end

    context "when a queue time contains a video that is already in the queue" do
      let(:video) { Fabricate(:video) }
      it "does not add a duplicate video" do
        ryan = Fabricate(:user)
        session[:user_id] = ryan.id
        Fabricate(:queue_item, video_id: video.id, user: ryan)
        post :create, video_id: video.id
        expect(ryan.queue_items.count).to eq(1)
      end
    end
    
    context "when a user is unauthenticated" do
      it "redirects to the sign in page for unauthenticated users" do
        post :create, video_id: 3
        expect(response).to redirect_to sign_in_path
      end
    end
    
  end
end