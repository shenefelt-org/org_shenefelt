class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.string :status
      t.integer :total_amount

      t.timestamps
    end
  end
end
