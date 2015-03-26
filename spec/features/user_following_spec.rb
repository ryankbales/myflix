require 'spec_helper'

feature 'User following' do
  scenario "user follows and unfollows someone" do
    category = Fabricate(:category)
    laura = Fabricate(:user)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user_id: laura.id, video_id: video.id)

    sign_in
    click_video_on_home_page(video)

    click_link laura.full_name
    click_link "Follow"
    expect(page).to have_content(laura.full_name)

    unfollows(laura)
    expect(page).not_to have_content(laura.full_name)

  end

  def unfollows(user)
    find("a[data-method='delete']").click
  end
end