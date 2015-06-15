require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_16DorUJQmdZI8GFqZAsj7ZUH",
      "created" => 1434341176,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_16DorTJQmdZI8GFqI1hHe5J6",
          "object" => "charge",
          "created" => 1434341175,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16DopcJQmdZI8GFqulBWdxM1",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2017,
            "fingerprint" => "mrJ2qZSux7TS267P",
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
            "customer" => "cus_6QfTA3yd0xbJex"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6QfTA3yd0xbJex",
          "invoice" => nil,
          "description" => "payment",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "Failed Payment",
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
            "url" => "/v1/charges/ch_16DorTJQmdZI8GFqI1hHe5J6/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6QgD3gdUV5ksyF",
      "api_version" => "2015-04-07"
    }
  end

  it "deactivates a user with the web hook from stripe for charge failed", :vcr do
    oscar = Fabricate(:user, customer_token: "cus_6QfTA3yd0xbJex")
    post "/stripe_events", event_data
    expect(oscar.reload).not_to be_active
  end
end