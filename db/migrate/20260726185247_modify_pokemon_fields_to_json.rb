class ModifyPokemonFieldsToJson < ActiveRecord::Migration[8.1]
  def change
    change_column :pokemons, :sprite_url, :json 
    change_column :pokemons, :game_idx, :json
  end
end
