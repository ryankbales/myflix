require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    laura = Fabricate(:user)
    sign_in(laura)
    page.should have_content laura.full_name
  end

  scenario "with valid email and password" do
    oscar = Fabricate(:user, active: false)
    sign_in(oscar)
    expect(page).not_to have_content(oscar.full_name)
    expect(page).to have_content("Your account has been deactivated.  Please give us a shout to fix it.")
  end
end