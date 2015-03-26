require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    
    it "sets @relationships to the current user's following relationships" do
      ryan = Fabricate(:user)
      set_current_user(ryan)
      laura = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: ryan.id, leader_id: laura.id)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

  end
end