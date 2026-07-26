json.extract! pokemon, :id, :name, :game_idx, :url, :sprite_url, :cry_url, :created_at, :updated_at
json.url pokemon_url(pokemon, format: :json)
