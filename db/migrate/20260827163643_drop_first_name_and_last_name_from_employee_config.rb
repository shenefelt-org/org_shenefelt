class DropFirstNameAndLastNameFromEmployeeConfig < ActiveRecord::Migration[8.1]
  def change
    remove_column :employee_configs, :first_name,  :string
    remove_column :employee_configs, :last_name,  :string
  end
end
