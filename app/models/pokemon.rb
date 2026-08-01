class Pokemon < ApplicationRecord
  has_one :evolution_chain, dependent: :destroy
  has_one :pokedex, dependent: :destroy, foreign_key: :pokemons_id, class_name: "Pokedex"
  serialize :game_idx, coder: JSON
  serialize :sprite_url, coder: JSON

  def get_game_version(version_name)
    return nil if game_idx.nil? || game_idx.empty?

    game = game_idx.find { |g| g['version'] == version_name }
    game ? game['game_index'] : nil
  end

  def get_all_versions
    return [] if game_idx.nil? || game_idx.empty?

    game_idx.map { |g| "#{g['version']} => pkmn_id: #{g['game_index']}" }
  end



end
