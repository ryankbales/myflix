require 'spec_helper'

describe RelationshipsController do
  let(:ryan) {Fabricate(:user)}
  let(:laura) {Fabricate(:user)}
  let(:ranger) {Fabricate(:user)}
  let(:relationship) {Fabricate(:relationship, follower_id: ryan.id, leader_id: laura.id)}
  let(:relationship2) {Fabricate(:relationship, follower_id: ranger.id, leader_id: laura.id)}
  describe "GET index" do
    
    it "sets @relationships to the current user's following relationships" do
      # ryan = Fabricate(:user)
      set_current_user(ryan)
      # laura = Fabricate(:user)
      # relationship = Fabricate(:relationship, follower_id: ryan.id, leader_id: laura.id)
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
  end
end