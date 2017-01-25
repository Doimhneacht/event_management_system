class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.datetime :time
      t.string :place
      t.string :purpose

      t.timestamps
    end
  end
end
