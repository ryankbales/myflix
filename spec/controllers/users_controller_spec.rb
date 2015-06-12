require 'spec_helper'

describe UsersController  do
  describe "GET new", :auth do

    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

  end

  describe "POST create" do
    context "successful user sign up" do

      it "should redirect to sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "valid personal info and declined card" do
      before do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '987654'
      end

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:error]).to be_present
      end

    end

    context "for failed user sign up" do
      it "renders new template" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user),stripeToken: '987653'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '987653'
        expect(flash[:error]).to be_present
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