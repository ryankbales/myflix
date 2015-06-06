require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    laura = Fabricate(:user)
    sign_in(laura)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    click_link "People"
    expect(page).to have_content laura.full_name
    sign_out

    sign_in(laura)
    click_link "People"
    expect(page).to have_content "Royal Ranger"

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Royal Ranger"
    fill_in "Friend's Email Address", with: "royalranger@email.com"
    fill_in "Invitation Message", with: "Join the App Ranger and Royal!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "royalranger@email.com"
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Royal Ranger"
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email", with: "royalranger@email.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
end