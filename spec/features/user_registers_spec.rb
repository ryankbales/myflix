require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do
  background do
    visit register_path
  end

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_valid_credit_card

    click_button "Sign Up"

    expect(page).to have_content("You are registered with MyFlix.  Please sign in now.")
  end

  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_invalid_credit_card

    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_invalid_credit_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "dax@email.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Dax Amillion"
  end

  def fill_in_valid_credit_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "6 - June", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_invalid_credit_card
    fill_in "Credit Card Number", with: "123"
    fill_in "Security Code", with: "123"
    select "6 - June", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "6 - June", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "dax@email.com"
  end

end