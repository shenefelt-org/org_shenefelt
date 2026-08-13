class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.timestamps
      t.string :name, null: true
      t.integer :group_id, null: true
    end
  end
end
