require 'spec_helper'

describe UsersController  do
  describe "GET new" do, :auth
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before { post :create, user: Fabricate.attributes_for(:user) }
      it "should create the user" do
        expect(User.count).to eq(1)
      end
      it "should redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with invalid input" do
      before { post :create, user: { password: "password", full_name: "Ryan Bales" } }
      it "does not create a user" do
        expect(User.count).to eq(0)
      end
      it "renders new template" do
        expect(response).to render_template :new
      end
      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end