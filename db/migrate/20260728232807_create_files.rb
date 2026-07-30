class CreateFiles < ActiveRecord::Migration[8.1]
  def change
    create_table :files do |t|
      t.timestamps
    end
  end
end
