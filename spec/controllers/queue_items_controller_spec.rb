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
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item"
    it "creates the queue item that is associated with the video"
    it "creates the queue item that is associated with the user"
    it "puts the video as the last video in the queue"
    it "does not add a duplicate video"
    it "redirects to the sign in page for unquthenticated users"
  end
end