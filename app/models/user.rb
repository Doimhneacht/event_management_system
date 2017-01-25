class User < ApplicationRecord
  has_and_belongs_to_many :events
  has_many :comments
  has_secure_password
  validates :email, presence: true, uniqueness: true
end
