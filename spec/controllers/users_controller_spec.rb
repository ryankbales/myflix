require 'spec_helper'

describe UsersController  do
  describe "GET new", :auth do

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

    context "sending emails" do
      
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "ryan@example.com", password: "password", full_name: "Ryan Bales"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["ryan@example.com"])
      end

      it "sends out email containing the user's name with valid input" do
        post :create, user: { email: "ryan@example.com", password: "password", full_name: "Ryan Bales"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Ryan Bales")
      end

      it "does not send out email with invalid input" do
        post :create, user: { email: "ryan@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    let(:laura) { Fabricate(:user) }
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3}
    end

    it "sets @user" do
      set_current_user
      get :show, id: laura.id
      expect(assigns(:user)).to eq(laura)
    end
  end
end