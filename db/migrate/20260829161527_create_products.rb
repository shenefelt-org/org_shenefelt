class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.integer :price_in_cents
      t.string :stripe_product_id
      t.string :stripe_price_id
      t.boolean :active

      t.timestamps
    end
  end
end
