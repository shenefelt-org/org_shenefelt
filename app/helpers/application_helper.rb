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

  # grab some random sprite url for the favicon
  def get_random_sprite_url
    temp = Pokemon&.count
    reurn nil if temp.zero?

    # use O(n) for now - this needs to be sped up 
    Pokemon.offset(rand(temp)).pluck(:sprite_url)&.first
    Pokemon.find_by(id: rand(temp))&.sprite_url
  end
end
