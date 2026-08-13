class AddCurlUrlToPokemon < ActiveRecord::Migration[8.1]
  def change
    add_column :pokemons, :curl_url, :string
  end
end
