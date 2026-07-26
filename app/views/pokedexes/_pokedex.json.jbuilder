json.extract! pokedex, :id, :flavor_text, :pokemon_id, :created_at, :updated_at
json.url pokedex_url(pokedex, format: :json)
