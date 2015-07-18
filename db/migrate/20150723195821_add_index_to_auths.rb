class AddIndexToAuths < ActiveRecord::Migration
  def change
    add_index :auths, [:provider, :uid, :user_id], unique: true
  end
end
