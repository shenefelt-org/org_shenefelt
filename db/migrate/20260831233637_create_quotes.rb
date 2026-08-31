class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      t.integer :quote_number

      t.timestamps
    end
  end
end
