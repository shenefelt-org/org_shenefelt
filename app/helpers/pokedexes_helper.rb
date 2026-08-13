module PokedexesHelper
    @endpoint = "https://pokeapi.co/api/v2/pokemon-species/"

    def get_national_dex_numbers
        return nil if Pokemon.all.count.zero?
        poke = Pokemon.all

        poke.each do |p|
            call = HTTParty.get("#{@endpoint}#{p.name}")
            next if !call.success?

            node = call.parsed_response.dig("pokedex_numbers", 0, "entry_number")
            next if node.nil?

            puts pastel.yellow("#{node} => #{p.name}\n")

            p.update!(
                game_idx: node
            )

            sleep 0.5
        end
    end

    def get_pokedex_entry_text
        pastel = Pastel.new

        if Pokemon.all.count.zero?
            puts pastel.red("No pokemon found in the database. Please run rake db:seed to populate the database with pokemon data.")
            return nil
        end
        poke = Pokemon.all

        poke.each do |p|
            if Pokedex.exists?(pokemons_id: p.id)
                puts pastel.yellow("Pokedex entry already exists for #{p.name}. Skipping.")
                next
            end
            call = HTTParty.get("#{@endpoint}#{p.name}")
            next if !call.success? # I anticipate some of these will fail due to mega evo and x evo
            p_res = call.parsed_response

            puts pastel.green("Creating pokedex entry for #{p.name}.")

            # only grabbing english cus why not
            english_text = p_res.dig("flavor_text_entries")&.find { |entry| entry.dig("language", "name") == "en" }

            # use squish to parse out the \n from the json entry
            version_name = p_res.dig("flavor_text_entries", 0, "version", "name")&.squish
            next if english_text.blank? || version_name.blank?

            Pokedex.create!(
                flavor_text: english_text,
                pokemons_id: p.id,
                version_name: version_name
            )

            puts pastel.green("Pokedex entry created for #{p.name}.\n\n")
            sleep 0.5
        end
    end

    # test methods
    def test_dex_grab(pokemon: nil)
        return nil if pokemon.nil?

        call = HTTParty.get("#{@endpoint}#{pokemon.name}")
        p_res = call.parsed_response
        puts pastel.cyan(p_res.dig("flavor_text_entries", 0, "flavor_text"))
        puts pastel.cyan(p_res.dig("flavor_text_entries", 0, "version", "name"))
    end


    # 
    def write_to_file
        return nil if Pokemon.all.size.zero?
        f_path = Rails.root.join("tmp", "pokedex_datum.csv")

        CSV.open(f_path, "w") do |csv|
            csv << [ "Flavor Text", "Pokemon", "Version Name" ]
            Pokemon.all.each do |poke|
                csv << [ poke.pokedex&.flavor_text, poke.name, poke.pokedex&.version_name ]
            end
        end
    end

    # filter out non english flavor texts
    def get_english_flavor_text(pokemon: nil)
        return nil if pokemon.nil?

        call = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon.name}")
        return nil unless call.success?

        dex_entry = Pokedex.find_by(pokemons_id: pokemon.id)
        return nil if dex_entry.nil?

        p_res = call.parsed_response
        english_text = p_res.dig("flavor_text_entries")&.find { |entry| entry.dig("language", "name") == "en" }

        dex_entry.update!(
            flavor_text: english_text&.dig("flavor_text")
        )

    rescue ActiveRecord::RecordInvalid => e
        puts pastel.red("Failed to update flavor text for #{pokemon.name}: #{e.message}")
        nil
        
    end

end
