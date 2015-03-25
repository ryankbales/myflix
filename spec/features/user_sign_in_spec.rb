require 'spec_helper'

feature "user signs in" do
  given(:laura) {Fabricate(:user)}
  scenario "with valid email and password" do
    sign_in(laura)
    page.should have_content laura.full_name
  end
end