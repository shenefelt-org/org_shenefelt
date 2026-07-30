class AddVersionNameAndFlavorTextEntryToPokedexes < ActiveRecord::Migration[8.1]
  def change
    add_column :pokedexes, :version_name, :string
    add_column :pokedexes, :flavor_text_entry, :text
  end
end
