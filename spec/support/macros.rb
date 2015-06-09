def set_current_user(user = nil)
  session[:user_id] = user ? user.id : Fabricate(:user).id
end

def set_current_admin(admin = nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def sign_in(user = nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def click_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end
