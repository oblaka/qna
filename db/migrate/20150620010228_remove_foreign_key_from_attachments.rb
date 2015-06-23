class RemoveForeignKeyFromAttachments < ActiveRecord::Migration
  def change
    remove_foreign_key :attachments, column: :attachable_id
  end
end
