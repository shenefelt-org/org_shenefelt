class AddBoxNumberToFunkoPops < ActiveRecord::Migration[8.1]
  def change
    add_column :funko_pops, :box_num, :integer
  end
end
