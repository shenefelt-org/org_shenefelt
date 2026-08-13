class DashboardPolicy < Struct.new(:user, :dashboard)
  # Can they see the dashboard at all?
  def show?
    user.present?
  end

  def view_pokedex_button?
    user.present?
  end

  def view_r2_storage_button?
    user.admin?
  end
end
