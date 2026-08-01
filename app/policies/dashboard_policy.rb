class DashboardPolicy < Struct.new(:user, :dashboard)
  # Can they see the dashboard at all?
  def show?
    user.present? # Example: Must be logged in
  end

  def view_pokedex_button?
    user.present? # Example: Only show the button if the user is logged in
  end

end

