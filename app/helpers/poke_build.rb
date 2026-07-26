require 'redis'
require 'httparty'

module PokeBuild
  @redis = Redis.new(host: '', port:1)

  def get_all_urls()
    call = HTTParty.get('https://pokeapi.co/api/v2/pokemon')
    return nil unless call.success?

    response = call.parsed_response['results']
    return nil if response.size.zero?

    response.each do |poke|
      puts "Parsing #{poke['name']}"
      add_to_hash(pokemon: {name: poke['name'], url: poke['url']})
    end

  end

  def add_to_hash(pokemon: nil)
  end


  def populate_build()
    node = Pokemon.create!

    parse_moves node
    parse_cries node
    parse_sprites node

    sleep 0.1
  end

  def parse_moves()
  end

  def parse_cries()
  end

  def parse_sprites()
  end
end
