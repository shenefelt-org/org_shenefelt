class DropGroupFkFromUserManagers < ActiveRecord::Migration[8.1]
  def change
    remove_column :user_managers, :group_id, :foreign_key
  end
end
