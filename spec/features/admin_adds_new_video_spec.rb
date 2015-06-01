require 'spec_helper'

feature 'Admin adds new video' do
  scenario "Admin successfully adds a new video" do
    admin = Fabricate(:admin)
    cult = Fabricate(:category, name: "Cult")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Clockwork Orange"
    find(:select).first(:option, 'Cult').select_option
    # select "Cult", from: "Category"
    fill_in "Description", with: "Freaky movie!"
    attach_file "Upload Large Cover Image", "spec/support/uploads/donnie_darko_large.jpg"
    attach_file "Upload Small Cover Image", "spec/support/uploads/donnie_darko_small.jpg"
    fill_in "Video URL", with: "http://www.iwantthistobedone.com"
    click_button "Add Video"

    sign_out

    sign_in

    visit video_path(Video.first)

    expect(page).to have_selector("img[src='/uploads/donnie_darko_large.jpg']")
    expect(page).to have_selector("a[href='http://www.iwantthistobedone.com']")
  end

end