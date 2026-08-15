class CreateClientContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :client_contacts do |t|
      t.references :contact, null: true, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
