require 'spec_helper'
require 'pry'
feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    dramas = Fabricate(:category)
    dances_with = Fabricate(:video, title: "Dances With Wolves", category: dramas)
    donnie = Fabricate(:video, title: "Donnie Darko", category: dramas)
    village = Fabricate(:video, title: "The Village", category: dramas)

    sign_in

    add_video_to_queue(dances_with)
    expect_video_to_be_in_queue(dances_with)

    visit video_path(dances_with)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(donnie)
    add_video_to_queue(village)

    set_video_position(dances_with, 3)
    set_video_position(donnie, 2)
    set_video_position(village, 1)
    
    update_queue

    expect_video_position(dances_with, 3)
    expect_video_position(donnie, 2)
    expect_video_position(village, 1)
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content "#{link_text}"
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(., '#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq("#{position}")
  end
end