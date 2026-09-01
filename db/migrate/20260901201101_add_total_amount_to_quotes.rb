class AddTotalAmountToQuotes < ActiveRecord::Migration[8.1]
  def change
    add_column :quotes, :total_amount, :integer
  end
end
