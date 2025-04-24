class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum schedule: { scheduled_to_attend: "出席予定" }
  enum attendances_status: { present: "出席中", away: "離席中" }

  validates :date, presence: true
  validates :remarks, length: { maximum: 20 }
  validates :user_id, presence: true
  validates :group_id, presence: true
  validate  :unique_user_group_date_combination, on: :create

  #同じ日に同じユーザーが同じグループに複数回出席登録されるのを防ぐ
  def unique_user_group_date_combination
    return unless date && user_id && group_id

    if Attendance.where(date: date, user_id: user_id, group_id: group_id).exists?
      errors.add(:base, "同じ日付で同じユーザー・グループの出席は既に存在します")
    end
  end

end
