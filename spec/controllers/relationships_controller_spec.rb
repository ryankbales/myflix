require 'spec_helper'

describe RelationshipsController do
  let(:ryan) { Fabricate(:user) }
  let(:laura) { Fabricate(:user) }
  let(:ranger) { Fabricate(:user) }
  let(:relationship) { Fabricate(:relationship, follower_id: ryan.id, leader_id: laura.id) }
  let(:relationship2) { Fabricate(:relationship, follower_id: ranger.id, leader_id: laura.id) }
  describe "GET index" do
    
    it "sets @relationships to the current user's following relationships" do
      set_current_user(ryan)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    describe "DELETE destroy" do

      it_behaves_like "requires sign in" do
        let(:action) {delete :destroy, id: 4}
      end

      it "deletes the relationship if the current user is the follower" do
        set_current_user(ryan)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end

      it "redirects to the people page" do
        set_current_user(ryan)
        delete :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end
      
      it "does not delete the relationship if the current user is not the follower" do
        set_current_user(ryan)
        delete :destroy, id: relationship2.id
        expect(Relationship.count).to eq(1)
      end
    end

    describe "POST create" do
      let(:ryan) { Fabricate(:user) }
      let(:laura) { Fabricate(:user) }

      it_behaves_like "requires sign in" do
        let(:action) {post :create, id: 4}
      end

      it "redirects to the people page" do
        set_current_user(ryan)
        post :create, leader_id: laura.id
        expect(response).to redirect_to people_path
      end

      it "creates a relationship that the current user follows the leader" do
        set_current_user(ryan)
        post :create, leader_id: laura.id
        expect(ryan.following_relationships.first.leader).to eq(laura)
      end

      it "does not create a relationship if the current user already follows the leader" do
        set_current_user(ryan)
        Fabricate(:relationship, leader: laura, follower: ryan)
        post :create, leader_id: laura.id
        expect(Relationship.count).to eq(1)
      end

      it "does not allow one to follow themselves" do
        set_current_user(ryan)
        post :create, leader_id: ryan.id
        expect(Relationship.count).to eq(0)
      end
    end
  end
end