class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :filename
      t.string :content_type
      t.binary :file_contents
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
