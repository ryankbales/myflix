Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Lorem.characters(10) }
  full_name { Faker::Name.name }
  admin false
  active true
end

Fabricator(:admin, from: :user) do
  admin true
end