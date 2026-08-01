class ChangeFlavorTextToTextInPokedexes < ActiveRecord::Migration[8.1]
  def change
    change_column :pokedexes, :flavor_text, :text
  end
end
