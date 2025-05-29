FactoryBot.define do
  factory :attendance do
    sequence(:date) { |n| Date.today + n.days }
    schedule { Attendance.schedules.keys.sample }
    attendances_status { Attendance.attendances_statuses.keys.sample }
    remarks { Faker::Lorem.sentence }

    association :user
    association :group
  end
end
