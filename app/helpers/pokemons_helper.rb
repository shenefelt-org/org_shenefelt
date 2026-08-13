# this makes a large amount of queries on our api guys
# we should bewary of running this at any other time than first unpack
# I increased the threshold on our payload size to 1360 to get all the pokemon in one call (poke_x server)
require "httparty"
require "csv"

module PokemonsHelper
  @endpoints = {
    base: "https://pokeapi.co/api/v2/pokemon/?limit=1360",
    poke_info: "https://pokeapi.co/api/v2/pokemon/",
    pokedex_info: "https://pokeapi.co/api/v2/pokemon-species/",
    type: "https://pokeapi.co/api/v2/type",
    item: "https://pokeapi.co/api/v2/item"
  }

  # collect base info at intro endpoint speed calc O(n) = (log(n) - {sum})
  def collect_name_url!
    call = HTTParty.get(@endpoints[:base])
    return nil unless call.success?

    response = call.parsed_response
    return nil if response.size.zero?

    res = response["results"]
    return nil if res.empty?

    res.each do |poke|
      name, url = poke["name"], poke["url"]
      puts "Creating #{name}\nURL: #{url}"

      node = Pokemon.create!(
        name: name,
        url: url
      )

      node_data = HTTParty.get(url).parsed_response

      # assign_game_idxs(pokemon: node, node_data: node_data)
      puts "Finished creating #{name}\nSleep 1 second..\n"

      sleep 0.5
    end
  end

  # parse out idx national dex id i.e. grab national pokeid != game specific ids
  def assign_national_dex_id!
    return nil if Pokemon.all.size.zero?
    nodes = Pokemon.all

    nodes.each do |poke|
      call = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{poke.name}")
      next if !call.success?

      node = call.parsed_response["pokedex_numbers"][0]["entry_number"]
      next if node.nil?

      puts "#{node} => #{poke.name}\n"

      poke.update!(
        game_idx: node
      )

      sleep 0.5
    end
  end

  def assign_sprites!
    return nil if Pokemon.all.size.zero?

    nodes = Pokemon.all

    nodes.each do |poke|
      call = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{poke.name}")
      node = call.parsed_response["sprites"]
      next if node.nil?
      puts "Assigning sprites for #{poke.name}"

      poke.update!(
        sprite_url: node["front_default"],
      )

      sleep 0.5
    end
  end

  # only parse legacy cry disregard future forward cry data.
  def assign_cries!
    return nil if Pokemon.all.size.zero?

    nodes = Pokemon.all

    nodes.each do |poke|
      call = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{poke.name}")
      node = call.parsed_response["cries"]
      next if node.nil?
      puts "Assigning legacy cry for #{poke.name}"

      poke.update!(
        cry_url: node["legacy"],
      )

      sleep 0.5
    end

    (Pokemon.where(cry_url: nil).size.zero?) ? (puts "All cries assigned!") : (puts "Some cries were not assigned! gathering data.")
  end

  # reset all id's game indx is not what I want assigned here tbh
  def void_all_ids!
    return nil if Pokemon.all.size.zero?

    Pokemon.all.each { |p| p.update!(game_idx: 0) }
  end

  # reset all sprite URLs
  def void_all_sprites!
    return nil if Pokemon.all.size.zero?

    Pokemon.all.each { |p| p.update!(sprite_url: nil) }
  end

  # reset all cry URLs
  def void_all_cries!
    return nil if Pokemon.all.size.zero?

    Pokemon.all.each { |p| p.update!(cry_url: nil) }
  end

  # output all data to CSV file for external use
  def write_to_file
    return nil if Pokemon.all.size.zero?
    f_path = Rails.root.join("tmp", "pokemon_data.csv")

    CSV.open(f_path, "w") do |csv|
      csv << [ "Name", "Game Index", "URL", "Sprite URL", "Cry URL" ]
      Pokemon.all.each do |poke|
        csv << [ poke.name, poke.game_idx, poke.url, poke.sprite_url, poke.cry_url ]
      end
    end
  end

  #
  # run datum collection sequence
  #
  def run_all
    assign_national_dex_id! if collect_name_url!
    assign_sprites! if assign_national_dex_id!
    assign_cries! if assign_sprites!
  end

  private

  def has_sprites?(pokemon: nil)
    return false if pokemon.nil?
    !pokemon.sprite_url.nil? && !pokemon.sprite_url.empty?
  end

  def has_cries?(pokemon: nil)
    return false if pokemon.nil?
    !pokemon.cry_url.nil? && !pokemon.cry_url.empty?
  end

  # check if a pokemon is missing a cry
  def missing_cries?(pokemon: nil)
    return false if pokemon.nil?
    pokemon.cry_url.nil? || pokemon.cry_url.empty?
  end
end
