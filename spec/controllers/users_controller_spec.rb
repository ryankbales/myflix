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

    context "when new user visits via an invite" do
      let(:laura) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter_id: laura.id, recipient_email: 'ryan@email.com') }

      before { post :create, user: {email: 'ryan@email.com', password: "password", full_name: 'Ry Dog'}, invitation_token: invitation.token }

      it "makes the user follow the inviter" do
        ryan = User.find_by_email('ryan@email.com')
        expect(ryan.follows?(laura)).to be_truthy
      end

      it "makes the inviter follow the user" do
        ryan = User.find_by_email('ryan@email.com')
        expect(laura.follows?(ryan)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be_nil
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

  describe "GET new_with_invitation_token" do
    let(:laura) { Fabricate(:user) }
    it "renders the :new view template" do
      invitation = Fabricate(:invitation, inviter_id: laura.id)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipients's email" do
      invitation = Fabricate(:invitation, inviter_id: laura.id)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation, inviter_id: laura.id)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: '2k4kek3k5k56'
      expect(response).to redirect_to expired_token_path
    end
  end
end