Fabricator(:review) do
  rating Faker::Number.digit
  review Faker::Lorem.paragraph(1)
  video_id nil
  user_id { Fabricate(:user).id }
end