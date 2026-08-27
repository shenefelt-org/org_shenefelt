class AddMembershipsForeignKeyToUserManagers < ActiveRecord::Migration[8.1]
  def change
    add_reference :user_managers, :membership, null: false, foreign_key: true
  end
end
