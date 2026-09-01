class AddCustomerForeginKeyToQuotes < ActiveRecord::Migration[8.1]
  def change
    remove_column :quotes, :customer_id
    add_reference :quotes, :customer, null: true, foreign_key: true
  end
end
