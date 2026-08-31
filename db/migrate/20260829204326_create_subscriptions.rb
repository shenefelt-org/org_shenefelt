class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.string :active
      t.string :billing_cycle_type

      t.timestamps
    end
  end
end
