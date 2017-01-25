class AddAssociationsToTables < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :event, index: true, foreign_key: true
    add_reference :comments, :user, index: true, foreign_key: true

    create_table :users_events, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
    end
  end
end
