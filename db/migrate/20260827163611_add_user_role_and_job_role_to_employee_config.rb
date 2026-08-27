class AddUserRoleAndJobRoleToEmployeeConfig < ActiveRecord::Migration[8.1]
  def change
    add_column :employee_configs, :user_role, :string
    add_column :employee_configs, :job_role, :string
  end
end
