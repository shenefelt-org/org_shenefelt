class CreateFunkoPops < ActiveRecord::Migration[8.1]
  def change
    create_table :funko_pops do |t|
      t.string :name
      t.float :cost
      t.float :current_value

      t.timestamps
    end
  end
end
