require 'httparty'

module PokemonsHelper
  @endpoints = {
    base: "https://pokeapi.co/api/v2/pokemon/?limit=1360",
    poke_info: "https://pokeapi.co/api/v2/pokemon/",
    pokedex_info: "https://pokeapi.co/api/v2/pokemon-species/",
    type: "https://pokeapi.co/api/v2/type",
    item: "https://pokeapi.co/api/v2/item",
  }

  # collect base info at intro endpoint speed calc O(n) = (log(n) - {sum})
  def collect_name_url
    call = HTTParty.get(@endpoints[:base])
    return nil unless call.success?

    response = call.parsed_response
    return nil if response.size.zero?

    res = response['results']
    return nil if res.empty?

    res.each do |poke|
      name, url = poke['name'], poke['url']
      puts "Creating #{name}\nURL: #{url}"

      node = Pokemon.create!(
        name: name,
        url: url
      )

      node_data = HTTParty.get(url).parsed_response

      assign_game_idxs(pokemon: node, node_data: node_data)
      puts "Finished creating #{name}\nSleep 1 second.."
      sleep 1
    end

  end

  def assign_game_idxs(pokemon: nil, node_data: nil)
    return nil if pokemon.nil? || node_data.nil?

    res = node_data["game_indices"]

    games = []

    res.each do |idx|
      games << {
        game_index: idx["game_index"],
        version: idx['version']['name']
      }
    end

    pokemon.update!(
      game_idx: games
    )
  end

  def assign_sprites(pokemon: nil, node_data: nil)
    return nil if pokemon.nil? || node_data.nil?

    sprites = node_data['sprites']

    pokemon.update!(
      sprites: sprites
    )
  end

  def assign_cries(pokemon: nil)
  end


end
