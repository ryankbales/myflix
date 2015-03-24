require 'spec_helper'

feature "user signs in" do
  given(:laura) {Fabricate(:user)}
  scenario "with valid email and password" do
    visit sign_in_path
    fill_in "Email", with: laura.email
    fill_in "Password", with: laura.password
    click_button "Sign in"
    page.should have_content laura.full_name
  end
end