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

User.find_each do |user|
  Group.find_each do |group|
    user.join_group(group)
  end
end

start_day = Date.new(2025, 4, 1)
end_day = Date.new(2025, 6, 30)
user_ids = User.ids
group_ids = Group.ids

(start_day..end_day).each do |day|
  5.times do
    last_user_id = nil
    selectable_ids = user_ids - [last_user_id].compact

    user_id = selectable_ids.sample
    group_id = group_ids.sample

    Attendance.create!(
      date: day,
      schedule: "出席予定",
      attendances_status: "出席中",
      user_id: user_id,
      group_id: group_id,
      )

    last_user_id = user_id
  end
end
