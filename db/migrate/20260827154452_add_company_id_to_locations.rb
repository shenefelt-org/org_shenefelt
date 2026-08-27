class AddCompanyIdToLocations < ActiveRecord::Migration[8.1]
  def change
    add_reference :locations, :companies, null: true, foreign_key: true
  end
end
