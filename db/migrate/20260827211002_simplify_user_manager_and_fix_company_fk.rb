class SimplifyUserManagerAndFixCompanyFk < ActiveRecord::Migration[8.1]
  def up
    # --- user_managers: stop requiring membership + employee_config ---
    if foreign_key_exists?(:user_managers, :memberships)
      remove_foreign_key :user_managers, :memberships
    end
    if column_exists?(:user_managers, :membership_id)
      remove_column :user_managers, :membership_id
    end

    if foreign_key_exists?(:user_managers, :employee_configs)
      remove_foreign_key :user_managers, :employee_configs
    end
    if column_exists?(:user_managers, :employee_config_id)
      remove_column :user_managers, :employee_config_id
    end

    # leftover from earlier group attempt
    if column_exists?(:user_managers, :group_id)
      if foreign_key_exists?(:user_managers, :groups)
        remove_foreign_key :user_managers, :groups
      end
      remove_column :user_managers, :group_id
    end

    # optional audit who created the user
    unless column_exists?(:user_managers, :created_by_id)
      add_reference :user_managers, :created_by, foreign_key: { to_table: :users }, null: true
    end

    # --- locations: companies_id -> company_id ---
    if column_exists?(:locations, :companies_id) && !column_exists?(:locations, :company_id)
      if foreign_key_exists?(:locations, column: :companies_id)
        remove_foreign_key :locations, column: :companies_id
      end

      rename_column :locations, :companies_id, :company_id

      unless foreign_key_exists?(:locations, :companies, column: :company_id)
        add_foreign_key :locations, :companies, column: :company_id
      end
    end

    # employee_config already has user_id + location_id + user_role/job_role
    # names live on users (first_name/last_name) — good, keep that
  end

  def down
    add_reference :user_managers, :membership, null: true, foreign_key: true
    add_reference :user_managers, :employee_config, null: true, foreign_key: true

    if column_exists?(:user_managers, :created_by_id)
      remove_reference :user_managers, :created_by, foreign_key: { to_table: :users }
    end

    if column_exists?(:locations, :company_id) && !column_exists?(:locations, :companies_id)
      if foreign_key_exists?(:locations, column: :company_id)
        remove_foreign_key :locations, column: :company_id
      end
      rename_column :locations, :company_id, :companies_id
      add_foreign_key :locations, :companies, column: :companies_id
    end
  end
end