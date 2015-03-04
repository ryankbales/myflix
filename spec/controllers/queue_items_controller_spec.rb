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
end