class AddOwnerToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :owner, :integer
  end
end
