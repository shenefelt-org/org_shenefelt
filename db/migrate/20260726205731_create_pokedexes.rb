class CreatePokedexes < ActiveRecord::Migration[8.1]
  def change
    create_table :pokedexes do |t|
      t.json :flavor_text
      t.references :pokemons, null: true, foreign_key: true

      t.timestamps
    end
  end
end
