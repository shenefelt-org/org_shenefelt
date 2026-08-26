class Avo::Resources::InjuryReport < Avo::BaseResource
  # self.icon = "tabler/outline/users"
  # self.avatar = {
  #   source: :avatar
  # }
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    # field :avatar, as: :avatar
    field :name, as: :text
    field :email, as: :text
    field :phone, as: :text
    field :injured_person, as: :text
    field :incident_date, as: :date
    field :location, as: :text
    field :description, as: :textarea
    field :severity, as: :text
  end
end
