class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, null: false
      t.references :question, index: true, null: false

      t.timestamps null: false
    end
  end
end
