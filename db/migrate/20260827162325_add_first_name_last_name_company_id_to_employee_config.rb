class AddFirstNameLastNameCompanyIdToEmployeeConfig < ActiveRecord::Migration[8.1]
  def change
    add_column :employee_configs, :first_name, :string
    add_column :employee_configs, :last_name, :string
    add_reference :employee_configs, :company, null: true, foreign_key: true
  end
end
