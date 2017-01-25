class Event < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :comments
  has_many :attachments
  validates :time, presence: true
  validates :owner, presence: true
  validate :time_cannot_be_in_the_past

  def time_cannot_be_in_the_past
    if time.present? && time <= DateTime.now
      errors.add(:time, "can't be in the past")
    end
  end
end
