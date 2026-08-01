class PokemonPolicy < ApplicationPolicy
  
  def show_delete?
    user.present? && user.admin?
  end

  def show_edit?
    user.admin? 
  end
end
