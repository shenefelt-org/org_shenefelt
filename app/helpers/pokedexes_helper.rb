module PokedexesHelper
    @endpoint = "https://pokeapi.co/api/v2/pokemon-species/"

    def get_entries
        return nil if Pokemon.count == 0
        poke = Pokemon.all 

        poke.each do |p|
            call = HTTParty.get("#{@endpoint}#{p.name}")
            return nil unless call.success?
            res = call.parsed_response

            res["results"].each do |val|
                #parse pout data and make new dex
                Pokedex.create!(
                    
                )
                p << val # establish relation
            end
        end
        call = HTTParty.get("#{@endpoint}#{}")
    end

end
