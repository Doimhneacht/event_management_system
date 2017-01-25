require_relative '20170119130140_add_associations_to_tables'

class FixupAssociations < ActiveRecord::Migration[5.0]
  def change
    revert AddAssociationsToTables

    create_join_table :users, :events
  end
end
