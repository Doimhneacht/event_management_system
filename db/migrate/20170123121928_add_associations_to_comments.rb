class AddAssociationsToComments < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :user, foreign_key: true
    add_reference :comments, :event, foreign_key: true
  end
end
