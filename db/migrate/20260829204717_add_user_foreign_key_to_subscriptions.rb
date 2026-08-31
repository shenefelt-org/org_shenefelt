class AddUserForeignKeyToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_reference :subscriptions, :user, null: true, foreign_key: true
  end
end
