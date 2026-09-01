class ChangeTotalCostToDecimalOnQuotes < ActiveRecord::Migration[8.1]
  def change
    remove_column :quotes, :total_amount, :integer
    add_column :quotes, :total_amount, :integer
  end
end
