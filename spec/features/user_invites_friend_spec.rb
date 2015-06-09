require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted', {js: true, vcr: true} do
    laura = Fabricate(:user)
    sign_in(laura)

    invite_a_friend
    friend_accepts_invitation
    sleep 10
    friend_signs_in
    click_link "People"
    expect(page).to have_content laura.full_name
    sign_out

    sign_in(laura)
    click_link "People"
    expect(page).to have_content("Ranger Royal")

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Ranger Royal"
    fill_in "Friend's Email Address", with: "dogs@email.com"
    fill_in "Invitation Message", with: "Join the App!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "dogs@email.com"
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Ranger Royal"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email", with: "dogs@email.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
end