class Attachment < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :filename, presence: true
  validates :content_type, presence: true
  validates :file_contents, presence: true
end
