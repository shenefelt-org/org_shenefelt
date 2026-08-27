class Avo::Resources::Location < Avo::BaseResource
  self.icon = "tabler/outline/map-pin"
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
    field :location_id, as: :number
    field :name, as: :text
    field :address, as: :text
    field :city, as: :text
    field :state, as: :text
    field :zip, as: :number
  end
end
