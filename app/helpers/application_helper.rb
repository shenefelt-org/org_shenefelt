module ApplicationHelper
  red_cred = Rails.application.credentials.dig(:redis)

  ENDPOINTS = {
    base: "https://pokeapi.co/api/v2/pokemon/?limit=1360",
    poke_info: "https://pokeapi.co/api/v2/pokemon/",
    pokedex_info: "https://pokeapi.co/api/v2/pokemon-species/",
    type: "https://pokeapi.co/api/v2/type",
    item: "https://pokeapi.co/api/v2/item"
  }

  REDIS = Redis.new(host: red_cred[:host], port: red_cred[:port])

  
end
