class AddLocationIdToEmployeeConfig < ActiveRecord::Migration[8.1]
  def change
    add_reference :employee_configs, :location, null: true, foreign_key: true
  end
end
