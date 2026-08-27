class CreateEmployeeConfigs < ActiveRecord::Migration[8.1]
  def change
    create_table :employee_configs do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
