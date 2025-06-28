images = ["dog.jpg", "cat.jpg", "bird.jpg"]
image_dir = Rails.root.join("db", "image")

100.times do
  User.create!(
    user_name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password123',
    avatar_image: File.open(image_dir.join(images.sample)),
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
end_day = Date.new(2025, 9, 30)
user_ids = User.ids
group_ids = Group.ids

(start_day..end_day).each do |day|
  used_user_ids = []
  52.times do
    selectable_ids = user_ids - used_user_ids
    user_id = selectable_ids.sample
    group_id = group_ids.sample

    break if selectable_ids.empty?

    Attendance.create!(
      date: day,
      schedule: :full_day_attendance,
      attendances_status: :present,
      user_id: user_id,
      group_id: group_id,
      )

      used_user_ids << user_id
  end
end
