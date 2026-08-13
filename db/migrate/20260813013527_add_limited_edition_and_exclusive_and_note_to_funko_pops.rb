class AddLimitedEditionAndExclusiveAndNoteToFunkoPops < ActiveRecord::Migration[8.1]
  def change
    add_column :funko_pops, :limited_edition, :boolean
    add_column :funko_pops, :exclusive, :boolean
    add_column :funko_pops, :note, :string
  end
end
