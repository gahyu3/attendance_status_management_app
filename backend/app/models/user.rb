class User < ApplicationRecord
devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable
include DeviseTokenAuth::Concerns::User
end
