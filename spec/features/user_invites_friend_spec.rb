require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted', {js: true, vcr: true} do
    laura = Fabricate(:user)
    sign_in(laura)

    full_name = create_a_friends_name
    friends_email = create_a_friends_email

    invite_a_friend(full_name, friends_email)
    friend_accepts_invitation(full_name, friends_email)
    friend_signs_in(friends_email)

    click_link "People"
    expect(page).to have_content laura.full_name
    sign_out

    sign_in(laura)
    click_link "People"
    expect(page).to have_content "Royal Ranger"

    clear_email
  end

  def create_a_friends_name
    Faker::Name.name
  end

  def create_a_friends_email
    Faker::Internet.email
  end

  def invite_a_friend(name, email)
    visit new_invitation_path
    fill_in "Friend's Name", with: name
    fill_in "Friend's Email Address", with: email
    fill_in "Invitation Message", with: "Join the App!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation(name, email)
    open_email email
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: name
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2015", from: "date_year"
    click_button "Sign Up"
  end

  def friend_signs_in(email)
    fill_in "Email", with: email
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
end