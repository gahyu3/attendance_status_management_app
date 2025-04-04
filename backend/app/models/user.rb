class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User

  has_many :attendances, dependent: :destroy
  has_many :attending_group, through: :attendances, source: :group

  has_many :group_memberships
  has_many :groups, through: :group_memberships

  validates :user_name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def join_group(group)
    groups << group unless groups.exists?(group.id)
  end
end
