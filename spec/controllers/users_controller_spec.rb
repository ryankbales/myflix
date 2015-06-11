require 'spec_helper'

describe UsersController  do
  describe "GET new", :auth do

    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

  end

  describe "POST create" do
    context "with valid info and credit card" do

      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "should create the user" do
        expect(User.count).to eq(1)
      end

      it "should redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "when new user visits via an invite", :vcr do

      let(:laura) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter_id: laura.id, recipient_email: 'ryan@email.com') }

      before do
        token = Stripe::Token.create(:card => {:number => "4242424242424242", :exp_month => 6, :exp_year => 2018, :cvc => "314"}, ).id

        charge = double(:charge, amount: 999, currency: "usd", source: token, description: "valid charge", successful?: true)
        
        StripeWrapper::Charge.should_receive(:create).and_return(charge)

        post :create, user: {email: 'ryan@email.com', password: "password", full_name: 'Ry Dog', stripeToken: charge.source, token: invitation.token} 
      end

      after { ActionMailer::Base.deliveries.clear }

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

    context "valid personal info and declined card" do
      before do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
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

    context "with invalid personal info" do

      before { post :create, user: { email: "ryan@example.com" } }

      it "does not create a user" do
        expect(User.count).to eq(0)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send out email with invalid input" do
        AppMailer.should_not_receive(:send_welcome_email)
      end
      
    end

    context "sending emails" do

      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "ryan@example.com", password: "password", full_name: "Ryan Bales"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["ryan@example.com"])
      end

      it "sends out email containing the user's name with valid input" do
        post :create, user: { email: "ryan@example.com", password: "password", full_name: "Ryan Bales"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Ryan Bales")
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