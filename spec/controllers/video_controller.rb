require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end
    
    it "redirects user to sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video
      expect(response).to redirect_to sign_in_path
    end
  end
end