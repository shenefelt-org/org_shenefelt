require "redis"
require "httparty"

module PokeBuild

  def get_pkmn_urls(redis: nil)
    call = HTTParty.get(ENV["pokeapi_base_url"])
    return nil unless call.success?

    response = call.parsed_response["results"]
    return nil if response.size.zero?

    response.each do |poke|
      puts "Parsing #{poke['name']}"

      node = Pokemon.create!(
        name: poke["name"],
        url: poke["url"]
      )

    end

    return true if Pokemon.count == response.size 

  end

  def add_to_hash(pokemon: nil)
    return nil if pokemon.nil?
    @redis.hset("pokemon", pokemon[:name], pokemon[:url])
  end


  def populate_build
    node = Pokemon.create!()

    parse_moves node
    parse_cries node
    parse_sprites node

    sleep 0.1
  end

  def parse_moves(pokemon: nil, redis: nil)
    return nil if pokemon.nil? || redis.nil?

    call = HTTParty.get(pokemon.url)
    return nil unless call.success?

    res = call.parsed_response


    sleep 0.1
    puts "Moves loaded for: #{pokemon.name}"
  end

  def parse_cries(pokemon: nil)
    return nil if pokemon.nil?

    call = HTTParty.get(pokemon.url)

    sleep 0.1

    puts "Cries loaded for: #{pokemon.name}"

  end

  def parse_sprites(pokemon: nil)
    return nil if pokemon.nil?

    call = HTTParty.get(pokemon.url)
    return nil unless call.success?

    res = call.parsed_response

    sleep 0.1
    puts "Sprites loaded for: #{pokemon.name}"
  end


  def start
    creds = Rails.application.credentials.dig(:redis)
    redis = Redis.new(host: creds[:host], port: creds[:port])

    puts "failed to build url list.." unless get_pkmn_urls(redis: redis)
    puts "failed to build pokemon list.." unless parse_cries
    puts "failed to build pokemon list.." unless parse_sprites

    puts "Success application build complete! Moving log files to R2"
    puts update_r2_log_files
  end
end
