class AddEvolutionChainFkToPokemons < ActiveRecord::Migration[8.1]
  def change
    add_reference :pokemons, :evolution_chain, null: true, foreign_key: true
  end
end
