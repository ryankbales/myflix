require 'spec_helper'

describe UserSignup do
  describe "#sign_up", :vcr do
    context "valid personal info and valid card" do
       before do
         customer = double(:customer, successful?: true)
         StripeWrapper::Customer.should_receive(:create).and_return(customer)
       end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe token", nil)
        expect(User.count).to eq(1)
      end
    end

    context "sending emails" do

      before do
        customer = double(:customer, successful?: true)
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "ryan@example.com", password: "password", full_name: "Ryan Bales")).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["ryan@example.com"])
      end

      it "sends out email containing the user's name with valid input" do
        UserSignup.new(Fabricate.build(:user, email: "ryan@example.com", password: "password", full_name: "Ryan Bales")).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Ryan Bales")
      end
    end

    context "when new user visits via an invite" do
      let(:laura) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter_id: laura.id, recipient_email: 'ryan@email.com') }

      before do
        customer = double(:customer, successful?: true)
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user, email: 'ryan@email.com', password: "password", full_name: 'Ry Dog')).sign_up("stripe token", invitation.token)
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
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe token", nil)
      end 

      it "does not create a user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end

      it "does not send out email with invalid input" do
        AppMailer.should_not_receive(:send_welcome_email)
      end
      
    end

    context "invalid personal info and valid card" do

      before do
        customer = double(:customer, successful?: true)
        UserSignup.new(User.new(email: "ryan@email.com")).sign_up("stripe token", nil)
      end 

      it "does not create a user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end

      it "does not send out email with invalid input" do
        AppMailer.should_not_receive(:send_welcome_email)
      end
      
    end
  end
end