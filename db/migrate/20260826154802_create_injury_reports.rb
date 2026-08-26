class CreateInjuryReports < ActiveRecord::Migration[8.1]
  def change
    create_table :injury_reports do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :injured_person
      t.date :incident_date
      t.string :location
      t.text :description
      t.string :severity

      t.timestamps
    end
  end
end
