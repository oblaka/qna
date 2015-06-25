class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :rate, default: 0
      t.references :votable, polymorphic: true, index: true
      t.references :voter, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
