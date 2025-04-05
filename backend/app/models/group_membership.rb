class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validate :check_duplicate_membership

  # グループに同じユーザーが存在するかチェック
  def check_duplicate_membership
    if GroupMembership.where(user_id: user_id, group_id: group_id).exists?
      errors.add(:base, "ユーザーはすでにグループに存在します")
    end
  end
end
