class CreateEvolutionChains < ActiveRecord::Migration[8.1]
  def change
    create_table :evolution_chains do |t|
      t.string :evolves_to
      t.string :evolves_from
      t.references :pokemons, null: true, foreign_key: true

      t.timestamps
    end
  end
end
