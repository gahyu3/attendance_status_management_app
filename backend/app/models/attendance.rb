class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum attendances_status: { present: "出席中", away: "離席中" }
end
