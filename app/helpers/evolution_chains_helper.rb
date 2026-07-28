require 'httparty'
# pull down /evoltion-chain endpoint
=begin
Model data:
1. evolves_to
2. evolves_from

Model relations
Pokemon => has_one :evolution_chain

=end
module EvolutionChainsHelper

    @endpoints = {
        species: "https://pokeapi.co/api/v2/pokemon-species/",
        evolution: "https://pokeapi.co/api/v2/evolution-chain/"
    }

    # this method produces a lot of overhead, relation data should not be rebuilt.
    def get_chains
        return nil if Pokemon.count.zero?

        # def rel to chains via pkmn model - gs
        Pokemon.all.each do |pkmn|
            puts "Fetching evolution chain for #{pkmn.name}."
            species = HTTParty.get("#{@endpoints[:species]}#{pkmn.name}")
            return nil unless species.success?
            
            chain = HTTParty.get(species.parsed_response["evolution_chain"]["url"])
            return nil unless chain.success?

            chain.each do |evo|
                # parse out data and make new chain
                EvolutionChain.create!(
                    evolves_to: Pokemon.find_by(name: evo["evolves_to"][0]["species"]["name"]).name,
                    evolves_from: Pokemon.find_by(name: evo["evolves_from"]["species"]["name"]).name ||= nil,
                    pokemons_id: pkmn.id
                )
            end

            puts "Gotta nap for half a second."
            sleep 0.5 # sleep half a second for resource reset
            puts "I'm up! again."


        end
    end
end
