require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do  
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 6,
        :exp_year => 2018,
        :cvc => "314"
      },
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 6,
        :exp_year => 2018,
        :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge, :vcr do
    describe ".create" do
      it "makes a successful charge" do
        response = StripeWrapper::Charge.create(
            amount: 999,
            currency: "usd",
            source: valid_token,
            description: "valid charge"
          )

        expect(response.successful?).to be_truthy
      end

      it "makes a card declined charge" do

        response = StripeWrapper::Charge.create(
            amount: 999,
            currency: "usd",
            source: declined_token,
            description: "invalid charge"
          )

        expect(response.successful?).to be_falsey
      end

      it "returns the error message for declined charges" do
        response = StripeWrapper::Charge.create(
            amount: 999,
            currency: "usd",
            source: declined_token,
            description: "invalid charge"
          )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer, :vcr   do
    describe ".create" do
      it "creates a customer with valid card" do
        oscar = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          email: oscar.email,
          source: valid_token
        )
        expect(response).to be_successful
      end
      it "does not create a customer with declined card" do
        oscar = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          email: oscar.email,
          source: declined_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for decline card" do
        oscar = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          email: oscar.email,
          source: declined_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end