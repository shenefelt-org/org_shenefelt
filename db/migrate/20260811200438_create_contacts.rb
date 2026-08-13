class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    drop_table :contacts
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.text :message
      t.boolean :responded

      t.timestamps
    end
  end
end
