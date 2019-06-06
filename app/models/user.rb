class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    validates :password, confirmation: { case_sensitive: true }
    has_secure_password     # Then we can call user.authenticate Method
end
