class AddVersionNameToPokedexes < ActiveRecord::Migration[8.1]
  def change
    remove_column :pokedexes, :version_name, :string
    add_column :pokedexes, :version_name, :string
    add_column :pokedexes, :locations, :string
  end
end
