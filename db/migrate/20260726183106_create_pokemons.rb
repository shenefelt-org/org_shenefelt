class CreatePokemons < ActiveRecord::Migration[8.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.json :game_idx
      t.string :url
      t.string :sprite_url
      t.string :cry_url

      t.timestamps
    end
  end
end
