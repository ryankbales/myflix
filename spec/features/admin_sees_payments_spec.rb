require 'spec_helper'

feature "Admin sees payments" do
  background do
    oscar = Fabricate(:user, full_name: "Oscar Dude", email: "oscar@email.com")
    Fabricate(:payment, amount: 999, user: oscar)
  end
  
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Oscar Dude")
    expect(page).to have_content("oscar@email.com")
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Oscar Dude")
    expect(page).to have_content("You do not have permission to do that.")
  end
end