class RenameVoterToUserVotes < ActiveRecord::Migration
  def change
    remove_index :votes, [:voter_type, :voter_id]
    remove_column :votes, :voter_type
    remove_column :votes, :voter_id
    add_reference :votes, :user, index: true, foreign_key: true
  end
end
