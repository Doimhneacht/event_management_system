class AddUserRefToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_reference :attachments, :user, foreign_key: true
  end
end
