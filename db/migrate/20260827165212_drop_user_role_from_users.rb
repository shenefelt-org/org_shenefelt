class DropUserRoleFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :user_role, :string
  end
end
