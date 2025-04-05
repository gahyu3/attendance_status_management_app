class Group < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :attending_users, through: :attendances, source: :user

  has_many :group_memberships
  has_many :users, through: :group_memberships

  validates :name, length: { maximum: 30 }

  def attend_user(user, date)
    attendances.find_or_create_by(user: user, date: date)
  end
end
