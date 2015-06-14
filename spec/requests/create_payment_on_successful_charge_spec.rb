require 'spec_helper'

describe "Create payment on successful charge" do
  let( :event_data) do
    {
      "id" => "evt_16Dg1IJQmdZI8GFqLAuL5M8X",
      "created" => 1434307188,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16Dg1IJQmdZI8GFq1X29sGcY",
          "object" => "charge",
          "created" => 1434307188,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16Dg1HJQmdZI8GFq7YCoO78R",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2017,
            "fingerprint" => "fRzDtqzYyQefT50I",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6QX57Avkf4RPPB"
          },
          "captured" => true,
          "balance_transaction" => "txn_16Dg1IJQmdZI8GFqUv0agn0T",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6QX57Avkf4RPPB",
          "invoice" => "in_16Dg1IJQmdZI8GFqD1aWyhpJ",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "MyFlix Subscription",
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "destination" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_16Dg1IJQmdZI8GFq1X29sGcY/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6QX5WCLuD3XsSb",
      "api_version" => "2015-04-07"
    }
  end
  context "when a payment is created successfully", :vcr do
    it "creates a payment with the webhook from stripe for charge succeeded" do
      post "stripe_events", event_data
      expect(Payment.count).to eq(1)
    end

    it "creates the payment associated with user" do
      oscar = Fabricate(:user, customer_token: "cus_6QX57Avkf4RPPB")
      post "stripe_events", event_data
      expect(Payment.first.user).to eq(oscar)
    end

    it "creates the payment with the amount" do
      oscar = Fabricate(:user, customer_token: "cus_6QX57Avkf4RPPB")
      post "stripe_events", event_data
      expect(Payment.first.amount).to eq(999)
    end

    it "creates the payment with reference id" do
      oscar = Fabricate(:user, customer_token: "cus_6QX57Avkf4RPPB")
      post "stripe_events", event_data
      expect(Payment.first.reference_id).to eq("ch_16Dg1IJQmdZI8GFq1X29sGcY")
    end
  end
  
end