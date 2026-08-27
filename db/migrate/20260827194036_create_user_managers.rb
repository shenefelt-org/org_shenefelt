class CreateUserManagers < ActiveRecord::Migration[8.1]
  def change
    create_table :user_managers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :employee_config, null: false, foreign_key: true

      t.timestamps
    end
  end
end
