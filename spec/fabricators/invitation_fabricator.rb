Fabricator(:invitation) do
  inviter_id nil
  recipient_name { Faker::Name.name }
  recipient_email { Faker::Internet.email }
  message { Faker::Lorem.sentence }
end