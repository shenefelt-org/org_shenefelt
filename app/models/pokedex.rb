class Pokedex < ApplicationRecord
  belongs_to :pokemon, foreign_key: :pokemons_id, class_name: "Pokemon"

  def next
    Pokedex.where("id > ?", id).order(id: :asc).first
  end

  def previous
    Pokedex.where("id < ?", id).order(id: :desc).first
  end
  
end
