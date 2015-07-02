class AddUniqIndexToVotes < ActiveRecord::Migration
  def change
    remove_index :votes, [:votable_type, :votable_id]
    add_index :votes, [:votable_type, :votable_id, :user_id], unique: true
  end
end
