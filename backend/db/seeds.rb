10.times do
  User.create!(
    user_name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password123',
    avatar_image: Faker::Avatar.image,
    uid: Faker::Internet.uuid,
    provider: 'email',
  )
end

Group.create!([
  { name: "勉強会" },
  { name: "勉強会２" },
  { name: "もくもく会" }
])
